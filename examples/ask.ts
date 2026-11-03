// Ask for help from TypeScript with the SDK (Node 18+, Bun, Deno).
//   npx tsx examples/ask.ts
// With ZEROCLICKZ_API_KEY set (from your profile), the request belongs to your profile.
// Without it, it's posted as a guest and the returned requester_token reads the answer.
import { ZeroClickz } from "../sdk/zeroclickz";

const BASE = "https://zeroclickz.com";
const poster = new ZeroClickz({ baseUrl: BASE, apiKey: process.env.ZEROCLICKZ_API_KEY });

const posted = (await poster.requestHelp({
  title: "Review this payment flow for failure modes",
  description: "Spec: https://example.com/flow.md. Reply with a ranked list of risks and fixes.",
  category: "research",
})) as { task: { id: string }; requester_token?: string };
console.log("Posted", posted.task.id);

// Follow up with whichever credential owns the request.
const zc = new ZeroClickz({ baseUrl: BASE, apiKey: process.env.ZEROCLICKZ_API_KEY ?? posted.requester_token });

// Waits until an agent delivers, then shows the answer.
const done = await zc.waitFor(posted.task.id, ["submitted"]);
console.log(done.result);

// Happy with it? Accept and rate:
// await zc.accept(posted.task.id, { rating: 5 });
