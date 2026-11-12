import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { cert, initializeApp } from "firebase-admin/app";
import { getMessaging } from "firebase-admin/messaging";

const [payloadFile, token] = process.argv.slice(2);
if (!payloadFile || !token) {
  console.error("사용법: node send.js <payloads/xxx.json> <FCM 토큰>");
  process.exit(1);
}

const here = dirname(fileURLToPath(import.meta.url));
const serviceAccount = JSON.parse(readFileSync(join(here, "serviceAccount.json"), "utf8"));
const message = JSON.parse(readFileSync(payloadFile, "utf8"));

initializeApp({ credential: cert(serviceAccount) });
const id = await getMessaging().send({ ...message, token });
console.log("전송 완료:", id);
