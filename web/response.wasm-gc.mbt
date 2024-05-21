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

type Response @js.JsValue

pub fn @js.FromJsValue::from_js_value(value : @js.JsValue) -> Response {
  Response(value)
}

pub fn @js.ToJsValue::to_js_value(value : Response) -> @js.JsValue {
  value.0
}

fn Response::make_with_string_ffi(
  body : @js.JsValue,
  init : @js.JsValue
) -> @js.JsValue = "peter-jerry-ye:worker/response" "make_with_string"

pub fn Response::make_with_string_js(
  body : @js.JsString,
  init : ResponseInit
) -> Response {
  Response::make_with_string_ffi(
    body |> @js.to_js_value,
    init |> @js.to_js_value,
  )
  |> @js.from_js_value
}

pub fn Response::make_with_string(
  body : String,
  init : ResponseInit
) -> Response {
  Response::make_with_string_js(@js.JsString::from_string(body), init)
}

fn Response::make_ffi() -> @js.JsValue = "peter-jerry-ye:worker/response" "make"

pub fn Response::make() -> Response {
  Response::make_ffi() |> @js.from_js_value
}

type ResponseInit @js.JsValue

pub fn @js.FromJsValue::from_js_value(value : @js.JsValue) -> ResponseInit {
  ResponseInit(value)
}

pub fn @js.ToJsValue::to_js_value(value : ResponseInit) -> @js.JsValue {
  value.0
}

fn ResponseInit::make_ffi() -> @js.JsValue = "peter-jerry-ye:worker/response_init" "make"

pub fn ResponseInit::make() -> ResponseInit {
  ResponseInit(ResponseInit::make_ffi())
}

fn ResponseInit::set_status_ffi(
  value : @js.JsValue,
  status : @js.JsValue
) -> @js.JsValue = "peter-jerry-ye:worker/response_init" "set_status"

pub fn set_status(self : ResponseInit, status : Int) -> ResponseInit {
  ResponseInit::set_status_ffi(
    self |> @js.to_js_value,
    status |> @js.to_js_value,
  )
  |> @js.from_js_value
}

pub fn ResponseInit::set_status_text_ffi(
  value : @js.JsValue,
  status_text : @js.JsValue
) -> @js.JsValue = "peter-jerry-ye:worker/response_init" "set_status_text"

pub fn set_status_text_js(
  self : ResponseInit,
  status_text : @js.JsString
) -> ResponseInit {
  ResponseInit::set_status_text_ffi(
    self |> @js.to_js_value,
    status_text |> @js.to_js_value,
  )
  |> @js.from_js_value
}

pub fn set_status_text(
  self : ResponseInit,
  status_text : String
) -> ResponseInit {
  self.set_status_text_js(@js.JsString::from_string(status_text))
}
