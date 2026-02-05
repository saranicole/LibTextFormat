# LibTextFormat
Library for Elder Scrolls Online Addons - Advanced Text Formatting and Parsing

## Development Status: alpha  
(unstable, use at your own risk)

## Description
This library is to add advanced text parsing and formatting, suitable for use in any precanned communication.

It allows addons to refer to variables in text, such as "{house}" which will output a formatted house link.

It also enables addons to create "protocols" in which you can encode an object into text, then decode it later to get the object back.

## Reason for being
Vanilla Lua text formatting is ok in simple circumstances, but it gets hard to read and tedious sprinkling lots of
```"hello"..GetDisplayName().."how are you"..punctuation``` everywhere.

Having filters enables much more readable text blobs, and allows you to pass around variables and adjust them as needed.

Additionally protocols enable encoding of data structures, which is helpful for use cases, such as passing data programmatically between users of the same addon.

## Basic Usage

### Setup
The first thing LibTextFormat requires you to do is to initialize it with a saved variables "namespace" so that it can save filters and similar objects specific to your addon.

First declare your saved vars
```
MyAddon.savedVars = ZO_SavedVars:NewAccountWide("MyAddon_Vars", 1, nil, {
libNamespace = {
  LTF = {}
}})

```

Then initialize LibTextFormat with the object.
```
MyAddon.LTF = MyAddon.LTF or LibTextFormat:New(MyAddon.savedVars.libNamespace.LTF)
```

You can register custom filters either one by one or in bulk, with the function doing any needed processing and returning the desired substitution.
Parameters are passed in sequentially and separated by a comma "," in the filter, with the filter string being separated out by a pipe "|".

```
{greeting,name|mytag}
```

Now you can also register "core" filters which includes the house filter, among others:
```
MyAddon.LTF:RegisterCore()
```

One by one:
```
MyAddon.LTF:RegisterFilter("mytag", function(greeting, name)
  return greeting..name
end)
```

Or in bulk:
```
local filters = {}

filters["mytag"] = function(greeting, name)
  return greeting..name
end

filters["double"] = function(number)
  return 2 x tonumber(number)
end

MyAddon.LTF:RegisterFiltersBulk(filters)
```


### Rendering

Once you have your filters registered, create a "scope" first which contains an object with key value pairs that represent the substitutions you want.

```
local scope = MyAddon.LTF.Scope({ greeting = "hello", name = GetDisplayName() })
```

Now that you have your scope, you can pass it around to your object however you like:
```
local template = "{greeting} {name}, how was your day today?"
d(MyAddon.LTF:format(template, scope))
```
This would render ```"hello MyUsername, how was your day today?"```

Note that when the filter takes a parameter, you can pass in the variable name as the first argument, it does not have to be the value.
So for
```"{houseId,userId|house}"```
and a scope of
```
{
  houseId = 72,
  userId = GetDisplayName()
}
```

It will render the house link.  The filter will retrieve the value of the variable name from the scope.

### Protocols

Protocols are not text substitutions, they are a way to encode objects in text.  You would use them to serialize an object and pass it somewhere else.

Go through the same steps as above, but with the registration part you will use RegisterProtocol

Registering a custom protocol with the defaults - note that "myprotocol" will be the tag analogous to a filter string:
```
MyAddon.LTF:RegisterProtocol("myprotocol")
```

Note that the default delimiters are the following:
```
  group = "\n"
  record = ";"
  item = ","
```

Registering a custom protocol with different delimiters for the groups, records, and items:
```
MyAddon.LTF:RegisterProtocol("myprotocol", {delimiters = { group = ":", record = ";", item = "," }})
```
Note that you cannot provide a delimiters object with only one field overridden, you have to pass in a complete delimiters object with all three fields, even if they match the default.

A protocol must pass an object that contains the field "text" for encoding, and a field "records" for decoding.
They can be the same scope object, so long as both of those fields are present.  If they are separate objects, they only need the field related to the encoding/decoding operation.

An encoding

Encoding scope:
```
local values = {
  records = {
    { "Alice", "Engineer", { "Lua", "ESO" } },
    { "Bob",   "Designer", { "UI", "UX" } },
    { "Cara",  "QA",       "Automation" },
  }
}

d(MyAddon.LTF:format("myprotocol", MyAddon.LTF.Scope(values))
```

With the overridden delimiters outputs
```
Alice;Engineer;Lua,ESO:Bob;Designer;UI,UX:Cara;QA;Automation
```

Decoding is accomplished like so:
```
MyAddon.LTF:decodeByProtocolName("myprotocol", MyAddon.LTF.Scope({ text = "Alice;Engineer;Lua,ESO:Bob;Designer;UI,UX:Cara;QA;Automation" })
```

Outputs:
```
{
  { "Alice", "Engineer", { "Lua", "ESO" } },
  { "Bob",   "Designer", { "UI", "UX" } },
  { "Cara",  "QA",       "Automation" },
}
```


### Available Core Filters

```
house:
* Params:  houseId, userId
* outputs a string in the format "|H1:housing:<<houseId>>:<<userId>>|h|h"
* Usage: "{houseId,userId|house}"

icon:
* Params:  link - texture path such as "EsoUI/Art/Journal/journal_Quest_Repeat.dds"
* Optional Params: width, height
* outputs a string in the format "|t<<width>>:<<height>>:<<link>>|t"
* Usage: "{link|icon}" or "{link,width|icon}" or "{link,width,height|icon}"
* Notes: If width is specified but not height, it will use the value of width for height

item:
* Params: itemId
* Optional Params: style - can be either empty (default) or "bracket" which generates LINK_STYLE_BRACKETS
* outputs a string with GetItemLink from itemId
* Usage: "{style|itemId}"
```

The remaining core filters:
Math - add,sub,mul,div,mod,pow,min,max,floor,ceil
String - split,join,substr,lower,upper,trim,gsub,startWith,endsWith,contains,replaceFirst,repeat
Utility - plural,number,string


### Links
[ESOUI](https://www.esoui.com/downloads/info4380-LibTextFormat.html)
[ESO Mods](https://mods.bethesda.net/en/elderscrollsonline/details/cec7b602-5dc0-4af0-a949-cd5483dc7329/LibTextFormat)
