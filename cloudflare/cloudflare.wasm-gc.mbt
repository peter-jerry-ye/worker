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
type Env @js.JsValue

///|
pub impl @js.FromJsValue for Env with from_js_value(value : @js.JsValue) -> Env {
  Env(value)
}

///|
pub impl @js.ToJsValue for Env with to_js_value(value : Env) -> @js.JsValue {
  value._
}

///|
fn Env::kv_ffi(self : @js.JsValue, binding : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "env_get"

///|
pub fn Env::kv_js(self : Env, binding : @js.JsString) -> KVNamespace {
  Env::kv_ffi(self |> @js.to_js_value, binding |> @js.to_js_value)
  |> @js.from_js_value
}

///|
pub fn kv(self : Env, binding : String) -> KVNamespace {
  self.kv_js(@js.JsString::from_string(binding))
}

///|
fn Env::d1_ffi(self : @js.JsValue, binding : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "env_get"

///|
pub fn d1_js(self : Env, binding : @js.JsString) -> D1Database {
  Env::d1_ffi(self |> @js.to_js_value, binding |> @js.to_js_value)
  |> @js.from_js_value
}

///|
pub fn d1(self : Env, binding : String) -> D1Database {
  self.d1_js(@js.JsString::from_string(binding))
}

///|
type KVNamespace @js.JsValue

///|
pub impl @js.FromJsValue for KVNamespace with from_js_value(value : @js.JsValue) -> KVNamespace {
  KVNamespace(value)
}

///|
pub impl @js.ToJsValue for KVNamespace with to_js_value(value : KVNamespace) -> @js.JsValue {
  value._
}

///|
fn KVNamespace::put_string_ffi(
  self : @js.JsValue,
  key : @js.JsValue,
  value : @js.JsValue
) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "kvnamespace_put_string"

///|
pub fn put_string_js(
  self : KVNamespace,
  key : @js.JsString,
  value : @js.JsString
) -> @js.Promise[Unit] {
  KVNamespace::put_string_ffi(
    self |> @js.to_js_value,
    key |> @js.to_js_value,
    value |> @js.to_js_value,
  )
  |> @js.from_js_value
}

///|
pub fn put_string(
  self : KVNamespace,
  key : String,
  value : String
) -> @js.Promise[Unit] {
  self.put_string_js(
    @js.JsString::from_string(key),
    @js.JsString::from_string(value),
  )
}

///|
fn KVNamespace::get_string_ffi(
  self : @js.JsValue,
  key : @js.JsValue
) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "kvnamespace_get_string"

///|
pub fn get_string_js(
  self : KVNamespace,
  key : @js.JsString
) -> @js.Promise[@js.Nullable[@js.JsString]] {
  KVNamespace::get_string_ffi(self |> @js.to_js_value, key |> @js.to_js_value)
  |> @js.from_js_value
}

///|
pub fn get_string(
  self : KVNamespace,
  key : String
) -> @js.Promise[@js.Nullable[@js.JsString]] {
  self.get_string_js(@js.JsString::from_string(key))
}

///|
type D1Database @js.JsValue

///|
pub impl @js.FromJsValue for D1Database with from_js_value(value : @js.JsValue) -> D1Database {
  D1Database(value)
}

///|
pub impl @js.ToJsValue for D1Database with to_js_value(value : D1Database) -> @js.JsValue {
  value._
}

///|
fn D1Database::prepare_ffi(
  self : @js.JsValue,
  query : @js.JsValue
) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "d1_prepare"

///|
pub fn prepare_js(
  self : D1Database,
  query : @js.JsString
) -> D1PreparedStatement {
  D1Database::prepare_ffi(self |> @js.to_js_value, query |> @js.to_js_value)
  |> @js.from_js_value
}

///|
pub fn prepare(self : D1Database, query : String) -> D1PreparedStatement {
  self.prepare_js(@js.JsString::from_string(query))
}

///|
type D1PreparedStatement @js.JsValue

///|
pub impl @js.FromJsValue for D1PreparedStatement with from_js_value(
  value : @js.JsValue
) -> D1PreparedStatement {
  D1PreparedStatement(value)
}

///|
pub impl @js.ToJsValue for D1PreparedStatement with to_js_value(
  value : D1PreparedStatement
) -> @js.JsValue {
  value._
}

///|
fn D1PreparedStatement::bind_ffi(
  self : @js.JsValue,
  values : @js.JsValue
) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "d1_prepared_statement_bind"

///|
pub fn bind_js(
  self : D1PreparedStatement,
  values : @js.JsArray[@js.JsValue]
) -> D1PreparedStatement {
  D1PreparedStatement::bind_ffi(
    self |> @js.to_js_value,
    values |> @js.to_js_value,
  )
  |> @js.from_js_value
}

///|
pub fn bind(
  self : D1PreparedStatement,
  values : Array[@js.JsValue]
) -> D1PreparedStatement {
  self.bind_js(values |> @js.JsArray::from_array)
}

///|
fn D1PreparedStatement::first_at_ffi(
  self : @js.JsValue,
  colName : @js.JsValue
) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "d1_prepared_statement_first_at"

///|
pub fn first_at_js(
  self : D1PreparedStatement,
  colName : @js.JsString
) -> @js.Promise[@js.JsValue] {
  D1PreparedStatement::first_at_ffi(
    self |> @js.to_js_value,
    colName |> @js.to_js_value,
  )
  |> @js.from_js_value
}

///|
pub fn first_at(
  self : D1PreparedStatement,
  colName : String
) -> @js.Promise[@js.JsValue] {
  self.first_at_js(@js.JsString::from_string(colName))
}

///|
fn D1PreparedStatement::first_ffi(self : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "d1_prepared_statement_first"

///|
pub fn first_js(
  self : D1PreparedStatement
) -> @js.Promise[@js.Nullable[@js.Record]] {
  D1PreparedStatement::first_ffi(self |> @js.to_js_value) |> @js.from_js_value
}

///|
pub fn first(
  self : D1PreparedStatement
) -> @js.Promise[@js.Nullable[@js.Record]] {
  self.first_js()
}

///|
fn D1PreparedStatement::run_ffi(self : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "d1_prepared_statement_run"

///|
pub fn run_js(self : D1PreparedStatement) -> @js.Promise[D1Response] {
  D1PreparedStatement::run_ffi(self |> @js.to_js_value) |> @js.from_js_value
}

///|
pub fn run(self : D1PreparedStatement) -> @js.Promise[D1Response] {
  self.run_js()
}

///|
fn D1PreparedStatement::all_ffi(self : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "d1_prepared_statement_all"

///|
pub fn all_js(self : D1PreparedStatement) -> @js.Promise[D1ResultRecord] {
  D1PreparedStatement::all_ffi(self |> @js.to_js_value) |> @js.from_js_value
}

///|
pub fn all(self : D1PreparedStatement) -> @js.Promise[D1ResultRecord] {
  self.all_js()
}

///|
type D1Response @js.JsValue

///|
pub impl @js.FromJsValue for D1Response with from_js_value(val : @js.JsValue) -> D1Response {
  D1Response(val)
}

///|
pub impl @js.ToJsValue for D1Response with to_js_value(val : D1Response) -> @js.JsValue {
  val._
}

///|
fn D1Response::success_ffi(self : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "d1_response_success"

///|
pub fn D1Response::success(self : D1Response) -> Bool {
  D1Response::success_ffi(self |> @js.to_js_value) |> @js.from_js_value
}

///|
fn D1Response::meta_ffi(self : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "d1_response_meta"

///|
pub fn D1Response::meta(self : D1Response) -> D1Meta {
  D1Response::meta_ffi(self |> @js.to_js_value) |> @js.from_js_value
}

///|
fn D1Response::error_ffi(self : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "d1_response_error"

///|
pub fn D1Response::error(self : D1Response) -> @js.JsValue {
  D1Response::error_ffi(self |> @js.to_js_value)
}

///|
type D1Meta @js.JsValue

///|
pub impl @js.FromJsValue for D1Meta with from_js_value(val : @js.JsValue) -> D1Meta {
  D1Meta(val)
}

///|
pub impl @js.ToJsValue for D1Meta with to_js_value(val : D1Meta) -> @js.JsValue {
  val._
}

///|
type D1ResultRecord @js.JsValue

///|
pub impl @js.FromJsValue for D1ResultRecord with from_js_value(
  val : @js.JsValue
) -> D1ResultRecord {
  D1ResultRecord(val)
}

///|
pub impl @js.ToJsValue for D1ResultRecord with to_js_value(val : D1ResultRecord) -> @js.JsValue {
  val._
}

///|
fn D1ResultRecord::results_ffi(self : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "d1_result_results"

///|
pub fn results_js(self : D1ResultRecord) -> @js.JsArray[@js.Record] {
  D1ResultRecord::results_ffi(self |> @js.to_js_value) |> @js.from_js_value
}

///|
pub fn results(self : D1ResultRecord) -> Array[@js.Record] {
  self.results_js().to_array()
}

///|
fn D1ResultRecord::success_ffi(self : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "d1_result_success"

///|
pub fn D1ResultRecord::success(self : D1ResultRecord) -> Bool {
  D1ResultRecord::success_ffi(self |> @js.to_js_value) |> @js.from_js_value
}

///|
fn D1ResultRecord::meta_ffi(self : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "d1_result_meta"

///|
pub fn D1ResultRecord::meta(self : D1ResultRecord) -> D1Meta {
  D1ResultRecord::meta_ffi(self |> @js.to_js_value) |> @js.from_js_value
}

///|
fn D1ResultRecord::error_ffi(self : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/cloudflare" "d1_result_error"

///|
pub fn D1ResultRecord::error(self : D1ResultRecord) -> @js.JsValue {
  D1ResultRecord::error_ffi(self |> @js.to_js_value)
}
