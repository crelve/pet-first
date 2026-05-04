/**
 * Contact Form API
 *
 * お問い合わせフォームの受信とFirestore保存
 * - CORS対応（Firebase Hosting からのリクエスト許可）
 * - 入力バリデーション
 * - Firestoreへの保存
 * - Slack通知
 */

import { onRequest, HttpsError, onCall } from "firebase-functions/v2/https";
import { setGlobalOptions } from "firebase-functions/v2";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import { SlackNotificationService } from "../services/slack";

// Set global options
setGlobalOptions({ region: "asia-northeast1" });

// Initialize admin if not already initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

interface ContactFormData {
  name: string;
  email: string;
  category: string;
  message: string;
  language: string;
  appName: string;
  userAgent?: string;
  timestamp?: string;
}

/**
 * お問い合わせフォーム送信API
 */
export const submitContactForm = onRequest(
  { cors: true },
  async (req, res) => {
    // Only allow POST
    if (req.method !== "POST") {
      res.status(405).json({ error: "Method not allowed" });
      return;
    }

    try {
      const data = req.body as ContactFormData;

      // Validation
      const errors: string[] = [];

      if (!data.name || data.name.trim().length === 0) {
        errors.push("Name is required");
      }

      if (!data.email || !isValidEmail(data.email)) {
        errors.push("Valid email is required");
      }

      if (!data.category) {
        errors.push("Category is required");
      }

      if (!data.message || data.message.trim().length < 10) {
        errors.push("Message must be at least 10 characters");
      }

      if (errors.length > 0) {
        res.status(400).json({ error: "Validation failed", details: errors });
        return;
      }

      // Sanitize and prepare data
      const contactData = {
        name: sanitize(data.name),
        email: data.email.toLowerCase().trim(),
        category: data.category,
        message: sanitize(data.message),
        language: data.language || "en",
        appName: data.appName || "Unknown",
        userAgent: data.userAgent || "",
        status: "new", // new, in_progress, resolved, closed
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        ipAddress: req.ip || req.headers["x-forwarded-for"] || "",
        notes: "", // Admin notes
      };

      // Save to Firestore
      const docRef = await db.collection("contactForms").add(contactData);

      logger.info(`Contact form submitted: ${docRef.id}`);

      // Send Slack notification
      await sendSlackNotification({
        id: docRef.id,
        name: contactData.name,
        email: contactData.email,
        category: contactData.category,
        message: contactData.message,
        language: contactData.language,
        appName: contactData.appName,
      });

      res.status(200).json({
        success: true,
        id: docRef.id,
        message: "Contact form submitted successfully",
      });
    } catch (error) {
      logger.error("Error submitting contact form:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  }
);

/**
 * お問い合わせ一覧取得API（管理者用）
 */
export const listContactForms = onCall(async (request) => {
  // 認証チェック（Firebase Auth必須）
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Authentication required");
  }

  try {
    const { status, limit = 50, startAfter } = request.data || {};

    let query = db
      .collection("contactForms")
      .orderBy("createdAt", "desc")
      .limit(limit);

    if (status) {
      query = query.where("status", "==", status);
    }

    if (startAfter) {
      const startDoc = await db.collection("contactForms").doc(startAfter).get();
      if (startDoc.exists) {
        query = query.startAfter(startDoc);
      }
    }

    const snapshot = await query.get();
    const forms = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
      createdAt: doc.data().createdAt?.toDate?.()?.toISOString() || null,
      updatedAt: doc.data().updatedAt?.toDate?.()?.toISOString() || null,
    }));

    return { forms, count: forms.length };
  } catch (error) {
    logger.error("Error listing contact forms:", error);
    throw new HttpsError("internal", "Failed to list contact forms");
  }
});

/**
 * お問い合わせステータス更新API（管理者用）
 */
export const updateContactFormStatus = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Authentication required");
  }

  const { id, status, notes } = request.data;

  if (!id) {
    throw new HttpsError("invalid-argument", "Document ID is required");
  }

  const validStatuses = ["new", "in_progress", "resolved", "closed"];
  if (status && !validStatuses.includes(status)) {
    throw new HttpsError(
      "invalid-argument",
      `Invalid status. Must be one of: ${validStatuses.join(", ")}`
    );
  }

  try {
    const updateData: Record<string, unknown> = {
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedBy: request.auth.uid,
    };

    if (status) {
      updateData.status = status;
    }

    if (notes !== undefined) {
      updateData.notes = notes;
    }

    await db.collection("contactForms").doc(id).update(updateData);

    return { success: true };
  } catch (error) {
    logger.error("Error updating contact form:", error);
    throw new HttpsError("internal", "Failed to update contact form");
  }
});

// Helper functions

function isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

function sanitize(input: string): string {
  return input
    .trim()
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#x27;");
}

/**
 * Slack通知を送信
 */
async function sendSlackNotification(data: {
  id: string;
  name: string;
  email: string;
  category: string;
  message: string;
  language: string;
  appName: string;
}): Promise<void> {
  try {
    // Slack Webhook URLを環境変数から取得
    const webhookUrl = process.env.SLACK_WEBHOOK_URL;

    if (!webhookUrl) {
      logger.warn("SLACK_WEBHOOK_URL is not configured, skipping notification");
      return;
    }

    const slackService = new SlackNotificationService(webhookUrl, data.appName);
    await slackService.sendContactNotification({
      id: data.id,
      name: data.name,
      email: data.email,
      category: data.category,
      message: data.message,
      language: data.language,
    });

    logger.info(`Slack notification sent for contact: ${data.id}`);
  } catch (error) {
    // Slack通知の失敗はログに記録するが、メインの処理は失敗させない
    logger.error("Failed to send Slack notification:", error);
  }
}
