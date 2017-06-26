module geany_plugin_d_api.geanyplugin;

import gtkc.gobjecttypes: GCallback;
import gtkc.gtktypes: GtkDialog, GtkWidget;
//~ import gtkc.gtktypes: gchar; //FIXME
alias gchar = char;
alias gboolean = bool;
alias gpointer = size_t*;

extern(System) @nogc nothrow:

/** Basic information about a plugin available to Geany without loading the plugin. */
struct PluginInfo
{
    /** The name of the plugin. */
    const(gchar)* name;
    /** The description of the plugin. */
    const(gchar)* description;
    /** The version of the plugin. */
    const(gchar)* _version;
    /** The author of the plugin. */
    const(gchar)* author;
}

/** Basic information for the plugin and identification. */
struct GeanyPlugin
{
    PluginInfo* info;  /**< Fields set in plugin_set_info(). */
    GeanyData*  geany_data;     /**< Pointer to global GeanyData intance */
    GeanyPluginFuncs* funcs;    /**< Functions implemented by the plugin, set in geany_load_module() */
    GeanyProxyFuncs*  proxy_funcs; /**< Hooks implemented by the plugin if it wants to act as a proxy
                                        Must be set prior to calling geany_plugin_register_proxy() */
    private GeanyPluginPrivate* priv;    /* private */
}

/** Callback functions that need to be implemented for every plugin. */
struct GeanyPluginFuncs
{
    /** Array of plugin-provided signal handlers @see PluginCallback */
    PluginCallback* callbacks;
    /** Called to initialize the plugin, when the user activates it (must not be @c NULL) */
    gboolean function(GeanyPlugin* plugin, gpointer pdata) init;
    /** plugins configure dialog, optional (can be @c NULL) */
    GtkWidget* function(GeanyPlugin* plugin, GtkDialog* dialog, gpointer pdata) configure;
    /** Called when the plugin should show some help, optional (can be @c NULL) */
    void function(GeanyPlugin* plugin, gpointer pdata) help;
    /** Called when the plugin is disabled or when Geany exits (must not be @c NULL) */
    void function(GeanyPlugin* p) cleanup;
}

/** Callback array entry type used with the @ref plugin_callbacks symbol. */
struct PluginCallback
{
    /** The name of signal, must be an existing signal. For a list of available signals,
     *  please see the @link pluginsignals.c Signal documentation @endlink. */
    const(gchar)* signal_name;
    /** A callback function which is called when the signal is emitted. */
    GCallback   callback;
    /** Set to TRUE to connect your handler with g_signal_connect_after(). */
    gboolean    after;
    /** The user data passed to the signal handler. If set to NULL then the signal
     * handler will receive the data set with geany_plugin_register_full() or
     * geany_plugin_set_data() */
    gpointer    user_data;
}

struct GeanyData;
struct GeanyProxyFuncs;
struct GeanyPluginPrivate;

void geany_load_module(GeanyPlugin* plugin);
