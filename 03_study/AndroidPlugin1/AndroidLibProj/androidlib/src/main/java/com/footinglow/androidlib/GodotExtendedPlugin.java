package com.footinglow.androidlib;

import androidx.annotation.NonNull;

import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.UsedByGodot;

public class GodotExtendedPlugin extends org.godotengine.godot.plugin.GodotPlugin{
    public GodotExtendedPlugin(Godot godot) {
        super(godot);
    }

    @NonNull
    @Override
    public String getPluginName() {
        return "GodotExtendedPlugin";
    }

    @UsedByGodot
    public String getMyMessage() {
        return "Hello, Android Plugin!";
    }
}
