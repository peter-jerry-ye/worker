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

pub type Optional[T] JsValue

pub impl[T] FromJsValue for Optional[T] with from_js_value(value : JsValue) -> Optional[T] {
  Optional(value)
}
pub impl[T] ToJsValue for Optional[T] with to_js_value(value : Optional[T]) -> JsValue {
  value._
}

pub fn is_undefined[T](self : Optional[T]) -> Bool {
  self._.is_undefined()
}

pub fn to_option[T : FromJsValue](self : Optional[T]) -> Option[T] {
  if self._.is_undefined() {
    None
  } else {
    Some(from_js_value(self._))
  }
}
