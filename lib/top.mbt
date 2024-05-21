//  Copyright 2024 International Digital Economy Academy
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
// 
//      http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

pub fn fetch_ffi(request : @web.Request, env : @cf.Env) -> @js.JsValue {
  fetch(request, env) |> @js.to_js_value
}

fn fetch(request : @web.Request, env : @cf.Env) -> @js.Promise[@web.Response] {
  let secured_router = Router::Router(
    fn {
      GET, "/api/kv" => Some(get_handler)
      PUT, "/api/kv" => Some(put_handler)
      _, _ => Some(hello_handler)
    },
  )
  let router = Router::Router(
    fn {
      GET, "/" => Some(hello_handler)
      PUT, "/api/d1/user" => Some(create_user)
      method, path =>
        if method == GET && starts_with(path, "/api/d1/user/") {
          Some(get_user_role)
        } else if starts_with(path, "/api") { // TODO: use slice match
          secured_router.to_handler() |> naive_auth_middleware |> @option.some
        } else {
          None
        }
    },
  )
  router.to_handler().apply(request, env)
}

fn starts_with(str : String, other : String) -> Bool {
  str.length() >= other.length() && for i = 0; i < other.length(); i = i + 1 {
    if str[i] != other[i] {
      return false
    }
  } else {
    true
  }
}

let hello_handler : Handler = Handler(
  fn(
    _request : @web.Request,
    _env : @cf.Env
  ) -> Option[@js.Promise[@web.Response]] {
    @web.Response::make_with_string("Hello, World!", @web.ResponseInit::make())
    |> @js.Promise::resolve
    |> @option.some
  },
)

let put_handler : Handler = Handler(
  fn(
    request : @web.Request,
    env : @cf.Env
  ) -> Option[@js.Promise[@web.Response]] {
    let text = request.text_js()
    text.bind(
      fn {
        t => {
          let text = t.to_string()
          @json5.parse(text).to_option().bind(
            fn {
              value => {
                let key = value.value("key")?.as_string()?
                let value = value.value("value")?.as_string()?
                Some(
                  env.kv("MY_KV_NAMESPACE").put_string(key, value).map(
                    fn(_unit) { @web.Response::make() },
                  ),
                )
              }
            },
          ).or(
            @web.Response::make_with_string(
              "failed to parse: \(text)",
              @web.ResponseInit::make().set_status(400),
            )
            |> @js.Promise::resolve,
          )
        }
      },
    )
    |> @option.some
  },
)

let get_handler : Handler = Handler(
  fn(
    request : @web.Request,
    env : @cf.Env
  ) -> Option[@js.Promise[@web.Response]] {
    let params = @web.URL::make(request.url()).searchParams()
    params.get("key").map(
      fn {
        key =>
          env.kv("MY_KV_NAMESPACE").get_string(key).map(
            fn(str : @js.Nullable[@js.JsString]) -> @web.Response {
              let result = str.to_option().map(@js.to_string).or("null")
              @web.Response::make_with_string(
                "\(key) -> \(result)",
                @web.ResponseInit::make(),
              )
            },
          )
      },
    )
  },
)

pub fn naive_auth_middleware(
  handler : Handler,
  ~with_fall_through : Bool = false
) -> Handler {
  Handler(
    fn(
      request : @web.Request,
      env : @cf.Env
    ) -> Option[@js.Promise[@web.Response]] {
      let headers = request.headers()
      if headers.get("Authorization").or("") == "MoonBit" {
        (handler.0)(request, env)
      } else if with_fall_through {
        None
      } else {
        @web.Response::make_with_string(
          "Unauthorized",
          @web.ResponseInit::make().set_status(401),
        )
        |> @js.Promise::resolve
        |> @option.some
      }
    },
  )
}
