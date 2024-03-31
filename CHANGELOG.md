# Changelog

## v0.3.0 - 2024-03-31

* Add support for Turbo Drive - See [#25](https://github.com/julienbourdeau/debugbar/pull/25) and [#26](https://github.com/julienbourdeau/debugbar/pull/26)
* Fix error "undefined method `adapter_name' for ActiveJob:Module" for Rails < 7.1 - See [#24](https://github.com/julienbourdeau/debugbar/pull/24)
* Limit the number of request to 25, configurable with `maxRequests` option - See [664f2c11](https://github.com/julienbourdeau/debugbar/commit/664f2c11e56f18a7c3e4a9fb83ba5b7e19fbb9a9)

### Breaking changes

In order to support Turbo Drive, I had to split the helper into two parts. Before the JavaScript file was loaded, 
directly in the body, but it has to be loaded in the head now. 

If you were passing configuation t `debugbar_javascript`, you must now pass it to `debugbar_body`.

```diff
<!DOCTYPE html>
<html>
  <head>
    ... 
+    <%= debugbar_head %>
  </head>
    
  <body>
    ...
-    <%= debugbar_javascript %>
+    <%= debugbar_body %>
  </body>
</html>
```

## v0.2.0 - 2024-02-28

* Introduce polling in case someone cannot use ActiveCable - See [8b262be7](https://github.com/julienbourdeau/debugbar/commit/8b262be7b644c7b587a6c3348bb02076053a344f)
  * https://debugbar.dev/docs/polling-mode
* Show more timings information (total time, DB runtime and CPU time) - See [c02531ed](https://github.com/julienbourdeau/debugbar/commit/c02531ed6e9d9c74df11d4d8c30e3fb7bf970852)
* Move main middleware higher in the chain - See [7ca51c10](https://github.com/julienbourdeau/debugbar/commit/7ca51c10c5999f7ad14a303c92083614551de134)
* Silence debugbar routes for quieter logs - See [efe491bd](https://github.com/julienbourdeau/debugbar/commit/efe491bde9e0544e5fb891597bb2af47854c1169)

### Breaking changes

The frontend configuration was slightly modified. If you customized the prefix for the debugbar routes or the channelName, you must update your config.
Prefix is at the root, and channelName is nested under the cable key.

```diff
- <%= debugbar_javascript channelName: "something_else", cable: {prefix: "custom-prefix"} %>
+ <%= debugbar_javascript prefix: "custom-prefix", cable: {channelName: "something_else"} %>
```

## v0.1.0 - 2024-02-13

* Initial release 🎉
