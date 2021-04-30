//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <entry/entry_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) entry_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "EntryPlugin");
  entry_plugin_register_with_registrar(entry_registrar);
}
