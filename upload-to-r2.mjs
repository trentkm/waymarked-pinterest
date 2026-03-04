// Upload a file to R2 and print the public URL
// Usage: node upload-to-r2.mjs <filepath> [key]
import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";
import { readFileSync } from "fs";
import { basename } from "path";
import { config } from "dotenv";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

config({ path: join(process.env.HOME, "repos/waymarked/.env.local") });

const client = new S3Client({
  region: "auto",
  endpoint: `https://${process.env.R2_ACCOUNT_ID}.r2.cloudflarestorage.com`,
  credentials: {
    accessKeyId: process.env.R2_ACCESS_KEY_ID,
    secretAccessKey: process.env.R2_SECRET_ACCESS_KEY,
  },
});

const filePath = process.argv[2];
const key = process.argv[3] || `reviews/pins/${basename(filePath)}`;

const body = readFileSync(filePath);

await client.send(new PutObjectCommand({
  Bucket: process.env.R2_BUCKET_NAME,
  Key: key,
  Body: body,
  ContentType: "image/png",
}));

console.log(`${process.env.R2_PUBLIC_URL}/${key}`);
