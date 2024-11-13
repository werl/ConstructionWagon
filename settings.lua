data:extend({
  {
    type = "string-setting",
    name = "ct-default-cargo-mode",
    setting_type = "runtime-per-user",
    default_value = "full",
    allowed_values = {"full", "disabled", "fill", "empty"}
  },
  {
    type = "color-setting",
    name = "ct-default-wagon-tint",
    setting_type = "startup",
    default_value = {1.0,0.757,0.169}
  }
})