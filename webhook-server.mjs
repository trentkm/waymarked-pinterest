// Minimal GitHub webhook server for processing pin reviews
// Listens on port 9876, verifies GitHub signature, runs process-reviews.sh
import { createServer } from "http";
import { createHmac } from "crypto";
import { writeFileSync } from "fs";

const PORT = 9876;
const SECRET = process.env.WEBHOOK_SECRET;

function verifySignature(payload, signature) {
  if (!SECRET) return true; // skip verification if no secret set
  const expected = "sha256=" + createHmac("sha256", SECRET).update(payload).digest("hex");
  return signature === expected;
}

const server = createServer((req, res) => {
  if (req.method !== "POST" || req.url !== "/webhook") {
    res.writeHead(404);
    res.end("Not found");
    return;
  }

  let body = "";
  req.on("data", (chunk) => { body += chunk; });
  req.on("end", () => {
    const signature = req.headers["x-hub-signature-256"] || "";

    if (!verifySignature(body, signature)) {
      console.log(`[${new Date().toISOString()}] Invalid signature, rejecting`);
      res.writeHead(401);
      res.end("Invalid signature");
      return;
    }

    let payload;
    try {
      payload = JSON.parse(body);
    } catch {
      res.writeHead(400);
      res.end("Invalid JSON");
      return;
    }

    const action = payload.action;
    const title = payload.issue?.title || "";

    // Only process closed issues with "Pin review:" in the title
    if (action === "closed" && title.startsWith("Pin review:")) {
      console.log(`[${new Date().toISOString()}] Processing: ${title}`);
      res.writeHead(200);
      res.end("Processing");

      // Write trigger file — launchd WatchPaths picks it up and runs the script
      const triggerFile = "/Users/trent/waymarked-pinterest/.run-reviews";
      setTimeout(() => {
        writeFileSync(triggerFile, `${new Date().toISOString()}\n`);
        console.log(`[${new Date().toISOString()}] Wrote trigger file`);
      }, 10000);
    } else {
      res.writeHead(200);
      res.end("Ignored");
    }
  });
});

server.listen(PORT, "127.0.0.1", () => {
  console.log(`[${new Date().toISOString()}] Webhook server listening on port ${PORT}`);
});
