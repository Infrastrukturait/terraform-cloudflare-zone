## Notes

### Cloudflare Zone settings

* If you try to use an argument that is available in a higher plan than your current one, the argument will be ignored without errors.
* If you try to set a value for the `security_level` or the `max_upload` argument that is not available on your current plan, the argument value will be set to the closest value available on your current plan.
* It is not necessary to specify all fields, such as `html`, `css`, and `js` in the `minify` [object](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone_settings_override#minify) (block in the original resource), even though according to the documentation all fields are required.
You can only specify the fields you need, the rest of the fields will take on the default values.
* It is not necessary to specify `status` and `strip_uri` fields in the `mobile_redirect` [object](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone_settings_override#mobile_redirect) (block in the original resource), even though according to the documentation these fields are required.
You can only specify the fields you need, the rest of the fields will take on the default values.

### Cloudflare record

* The `name` and the `data.name` argument values default to `@` (root). This is actually the default behavior, but only for the value of the `data.name` argument when you are not using the module.
* The `data` argument is fully supported. The `value` argument takes precedence over the `data` argument to avoid errors if two arguments are accidentally given at the same time, since only one of them can be given at the same time.
* The `ttl` argument value defaults to `1` (automatic). This is actually the default behavior.
* The `ttl` argument value is forced to `1` (automatic), regardless of explicitly set value, if you set the `proxied` argument value to `true`.
* The `proxied` argument value defaults to `false`. This is actually the default behavior. You must explicitly set this argument value to `true` for the records that you want to proxy through Cloudflare.
* The `proxied` argument value is forced to `false` for unsupported record types, regardless of explicitly set value.
* The `proxied` argument value is forced to `false` for wildcard records for non-enterprise plans, regardless of explicitly set value, because non-enterprise customers can create but not proxy wildcard records.
