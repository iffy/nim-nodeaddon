const addon = require('./index');

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
addon.showArgs(1, "two", true, [1,2,3], {"foo": "bar"})

