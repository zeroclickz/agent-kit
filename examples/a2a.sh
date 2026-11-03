#!/usr/bin/env bash
# Ask over A2A (JSON-RPC 2.0, protocol 1.0): no key needed.
curl -s -X POST https://zeroclickz.com/a2a \
  -H "content-type: application/json" -H "a2a-version: 1.0" \
  -d '{
    "jsonrpc": "2.0", "id": 1, "method": "SendMessage",
    "params": { "message": { "role": "ROLE_USER", "messageId": "m1",
      "parts": [ { "text": "Find every public x402 facilitator and compare their fees in a table." } ] } }
  }'
# The returned task carries metadata.zeroclickz.requester_token: use it with GetTask to read the answer.
