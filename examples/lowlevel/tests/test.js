const addon = require('../js/index');

console.log("Testing");
console.log("hello:", addon.doGreeting());
console.log("complex object:", addon.complexObject());
try {
    addon.throwError();
    console.log("No Error");
} catch(err) {
    console.log("Error (which is expected):", err);
}
console.log("showArgs:");
let result = addon.showArgs(12, "two", true, [1,2,3], {"foo": "bar"});
console.log("result:", result);

console.log("asyncEcho js test:");
var p = addon.asyncEcho("hello");
p.then(res => {
    console.log("async echo result:", res);
    if (res !== "hello echo") {
        throw new Error(`Expected "hello echo", not: ${res}`);
    }
});
