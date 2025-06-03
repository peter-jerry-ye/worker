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

///|
pub(all) enum HTTP_Request_Method {
  GET
  HEAD
  POST
  PUT
  DELETE
  CONNECT
  OPTIONS
  PATCH
} derive(Eq)

///|
pub fn HTTP_Request_Method::from_string(s : String) -> HTTP_Request_Method? {
  match s {
    "GET" | "get" => Some(HTTP_Request_Method::GET)
    "HEAD" | "head" => Some(HTTP_Request_Method::HEAD)
    "POST" | "post" => Some(HTTP_Request_Method::POST)
    "PUT" | "put" => Some(HTTP_Request_Method::PUT)
    "DELETE" | "delete" => Some(HTTP_Request_Method::DELETE)
    "CONNECT" | "connect" => Some(HTTP_Request_Method::CONNECT)
    "OPTIONS" | "options" => Some(HTTP_Request_Method::OPTIONS)
    "PATCH" | "patch" => Some(HTTP_Request_Method::PATCH)
    _ => None
  }
}

///|
pub(all) type Handler (@web.Request, @cf.Env) -> @js.Promise[@web.Response]?

///|
pub fn or(self : Handler, other : Handler) -> Handler {
  Handler(fn(
    request : @web.Request,
    env : @cf.Env
  ) -> @js.Promise[@web.Response]? {
    match (self._)(request, env) {
      Some(response) => Some(response)
      None => (other._)(request, env)
    }
  })
}

///|
pub fn apply(
  self : Handler,
  request : @web.Request,
  env : @cf.Env,
  default~ : @js.Promise[@web.Response] = @web.Response::make_with_string(
      "Not Found",
      @web.ResponseInit::make().set_status(404),
    )
    |> @js.Promise::resolve
) -> @js.Promise[@web.Response] {
  (self._)(request, env).or(default)
}

///|
pub(all) type Router (HTTP_Request_Method, String) -> Handler?

///|
pub fn to_handler(self : Router) -> Handler {
  let Router(router) = self
  Handler(fn(
    request : @web.Request,
    env : @cf.Env
  ) -> @js.Promise[@web.Response]? {
    let path = @web.URL::make(request.url()).pathname()
    HTTP_Request_Method::from_string(request.method())
    .bind(fn { m => router(m, path) })
    .bind(fn { Handler(handler) => handler(request, env) })
  })
}

///|
pub(all) type MiddleWare (Handler) -> Handler
