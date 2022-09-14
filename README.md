# Custom Local Fastlane Action for uploading ipa to AppStore connect via altool
I have created this custom action from [this plugin](https://github.com/XCTEQ/fastlane-plugin-altool) and adapted to my needs.
In particolar I wanted to have the possibility to use the API keys instead of uname/password as well as the possibility to run the `validate-app`.

The primarily reason why I wrote this is because of [this issue](https://github.com/fastlane/fastlane/issues/20371) and still wanted to use Fastlane as I am managing multiple apps.

I want to share this in case someone has the same needs. However I am *NOT* planning to make this a plugin and I am *NOT* going to maintain this based on request. Feel free to clone it and use it as you wish.


## Command
The action takes the following parameters (specified are the default values):
```
upload_ipa_altool(
  app_type: "iOS",
  key_id: ENV["APPLE_KEY_ID"],
  key_issuer: ENV["APPLE_KEY_ISSUER_ID"],
  output_format: "json",
  ipa_path: "./*.ipa", #the latest available,
  validate: false,
  verbose: false)
```

## Notes

- The `key_id` and `key_issuer` are the ones which are generated when creating the Key according to https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api

- The private key file must be place in `~/.appstoreconnect/private_keys` and must be named 'AuthKey_<key_id>.p8'. See `xcrun altool --help` for nice documentation

- By default the action uploads the ipa file present in the directory

- if `validate` is set to be `false` it will use `upload-app` and this should be replaced in the future as it's marked as deprecated


Hope this will help in speeding up your productive day.
