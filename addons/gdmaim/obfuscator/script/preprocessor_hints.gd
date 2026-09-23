extends RefCounted


const KEEP_ALL_MEMBERS : String = "KEEP_ALL_MEMBERS" # Lock all top-level members, public and private. Implies KEEP_PUBLIC_MEMBERS.
const KEEP_PUBLIC_MEMBERS : String = "KEEP_PUBLIC_MEMBERS" # Lock top-level members not starting with "_".
const LOCK_SYMBOLS : String = "LOCK_SYMBOLS"
const OBFUSCATE_STRINGS : String = "OBFUSCATE_STRINGS"
const OBFUSCATE_STRING_PARAMETERS : String = "OBFUSCATE_STRING_PARAMETERS" # param0, param1, ...
const FEATURE_FUNC : String = "FEATURE_FUNC" # feature_tag #TODO

# Deprecated hints: still honoured, but warn on export.
const KEEP_PUBLIC_API : String = "KEEP_PUBLIC_API" # Deprecated: use KEEP_PUBLIC_MEMBERS

## Deprecated hint -> replacement.
const DEPRECATED : Dictionary = {
	KEEP_PUBLIC_API: KEEP_PUBLIC_MEMBERS,
}
