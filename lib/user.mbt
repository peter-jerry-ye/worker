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

// Assume a table is created
// wrangler d1 execute MY_DB --command 'CREATE TABLE IF NOT EXISTS users(id VARCHAR(50), password VARCHAR(50), role VARCHAR(50));'
let create_user : Handler = Handler(
  fn(
    request : @web.Request,
    env : @cf.Env
  ) -> Option[@js.Promise[@web.Response]] {
    let text = request.text()
    text.bind(
      fn {
        t => {
          let text = t.to_string()
          @json.parse(text).to_option().bind(
            fn {
              value => {
                let username = value.value("username")?.as_string()?
                let password = value.value("password")?.as_string()?
                let role = value.value("role").bind(@json.as_string).or(
                  "visitor",
                )
                let d1 = env.d1("MY_DB")
                d1.prepare(
                  #| INSERT INTO users (id, password, role) VALUES (?1, ?2, ?3)
                  ,
                ).bind(
                  [
                    @js.from_string(username) |> @js.to_js_value,
                    @js.from_string(password) |> @js.to_js_value,
                    @js.from_string(role) |> @js.to_js_value,
                  ],
                ).run().map(
                  fn {
                    result =>
                      if result.success() {
                        @web.Response::make()
                      } else {
                        @web.Response::make_with_string(
                          "failed to insert",
                          @web.ResponseInit::make().set_status(500),
                        )
                      }
                  },
                )
                |> @option.some
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

let get_user_role : Handler = Handler(
  fn(
    request : @web.Request,
    env : @cf.Env
  ) -> Option[@js.Promise[@web.Response]] {
    let username : String = @web.URL::make(request.url()).pathname().substring(
      start="/api/d1/user/".length(),
    )
    let d1 = env.d1("MY_DB")
    d1.prepare(
      #| SELECT role FROM users WHERE id = ?1
      ,
    ).bind([@js.JsString::from_string(username) |> @js.to_js_value]).first_at(
      "role",
    ).map(
      fn {
        role =>
          if role.is_string() {
            @web.Response::make_with_string_js(
              role |> @js.from_js_value,
              @web.ResponseInit::make().set_status(200),
            )
          } else {
            @web.Response::make_with_string(
              "failed to get role of \(username)",
              @web.ResponseInit::make().set_status(404),
            )
          }
      },
    )
    |> @option.some
  },
)
