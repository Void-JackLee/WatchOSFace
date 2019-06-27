//
//  Strings.swift
//  SpriteWatchInterface
//
//  Created by 李弘辰 on 2019/6/24.
//  Copyright © 2019 李弘辰. All rights reserved.
//

import Foundation


let string_themes = getString("string_themes", "Themes")
let string_window_main_title = getString("window_main_title", "WatchFace on Mac")
let string_message_tmp_1 = getString("string_message_tmp_1", "Found unsaved theme \"")
let string_message_tmp_2 = getString("string_message_tmp_2", "\", do you want to continue your work?")
let string_button_continue = getString("button_continue", "Continue")
let string_button_create_new_theme = getString("button_create_new_theme", "Create new theme")
let string_touchbar_description_fresh_list = getString("touchbar_description_fresh_list", "Fresh List Button")
let string_touchbar_description_add = getString("touchbar_description_add", "Add button")
let string_touchbar_description_expand = getString("touchbar_description_expand", "Expand button")
let string_empty_name = getString("string_empty_name", "Name can't be empty!")
let string_invalid_name = getString("string_invalid_name", "Name can't contain ?*#./")
let string_touchbar_description_ok =  getString("touchbar_description_ok", "OK Button")
let string_button_ok = getString("button_ok", "OK")
let string_touchbar_description_cancel = getString("touchbar_description_cancel", "Cancel Button")
let string_button_cancel = getString("button_cancel", "Cancel")
let string_window_theme_add_title = getString("window_theme_add_title", "Add New Theme")
let string_button_back = getString("button_back", "Back")
let string_message_discard_change = getString("string_message_discard_change","Discard all changes and cancel adding?")

let string_touchbar_description_element_add = getString("touchbar_description_element_add","Add Element Button")
let string_touchbar_description_element_remove = getString("touchbar_description_element_remove", "Remove Element Button")
let string_touchbar_description_theme_confirm = getString("touchbar_description_theme_confirm", "Confirm Theme Button")
let string_touchbar_description_theme_edit_cancel = getString("touchbar_description_theme_edit_cancel", "Cancel Edit Theme Button")





func getString(_ sourceName : String, _ comment : String) -> String
{
    return NSLocalizedString(sourceName, comment: comment)
}
