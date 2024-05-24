## Moonbit's Cloudflare Worker Demo

This project showcases how to use MoonBit to develop a cloudflare worker.

### Project architecture

This project contains four packages:

- `js`: Core JavaScript binding. Binds things that is defined in the ECMAScript.
- `web`: API that are part of the [WinterCG](https://wintercg.org/). In other
  words, standard APIs.
- `cloudflare`: Cloudflare APIs.
- `lib`: Actual server definition. Inspired by [http4s](https://http4s.org/)
  though naively defined.

The bindings are expected to be generated from an IDL in the future.

### FFI design

The FFIs are divided to three layers:

- `*_ffi`: All parameters and results are `JS_Value`, which stands for any value
  in JavaScript.
- `*_js`: All parameters and results are specific JS types, except for
  `Promise[T]` (Warning: Do not try to create `Promise[Promise[T]]`).
- `*`: `Array` and `String` are converted to MoonBit type for ergonomics.

### Run the project

All you need is `moon` `node` and `pnpm`.

You can simply run `pnpm install` and then `pnpm dev`. The `wrangler` will spin
up a server, and you can access it with the commands provided.

You may use `curl` or other means to visit all the APIs. The expected behavior
is specified in the `test/index.spec.ts`. Simply run `pnpm test` and check that
it still works.
