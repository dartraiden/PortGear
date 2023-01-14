PortGear automatically swaps any gear with a teleport effect back to what you originally had equipped, such as the three guild Orgrimmar/Stormwind cloaks, the Kirin Tor rings, the Brawl rings, and so on.

The following will result in port gear being swapped to the previous item (if there was a previous item):

* item is not in the currently equipped set (if there are saved sets)

**AND**

* item was not worn at login/reload or **/portgear** wasn't used since it was equipped

**AND**

* player successfully uses the port gear

Use the slash command /portgear (or /pg for short) to "save" all **changed non-set port gear** after login/reload so they won't get swapped. The gear you are wearing will be remembered at login/reload, so /portgear is to save you from doing a /reload. If you use the Equipment Manager for all gear or don't normally wear port gear, you do not need to worry about /portgear. For example, if you don't save your tabards in sets and equip a port tabard, use /portgear to keep the tabard on if you use it.

If, for some reason, I have not updated this addon in a timely manner for new items, simply open gearlist.lua and add them at the bottom using the itemID.

As a sort of nod, this addon was born from using [TeleportCloak](https://mods.curse.com/addons/wow/teleportcloak). That addon has been great to me for almost two years, but some minor issues encouraged me to try my own.
