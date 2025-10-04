// Copilot Guidelines - Sigma Track

// 1) Extensions (mandatory)
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
// Access: context.theme|textTheme|colorScheme|colors|semantic|isDarkMode
// Access: context.l10n|locale|isEnglish|isIndonesian|isJapanese

// 2) Theming (never hardcode colors!)
// ✅ DO: context.colorScheme.primary, context.colors.surface, context.textTheme.bodyMedium
// ❌ DON'T: Color(0xFF...), Colors.red, hardcoded colors

// 3) Logging (replace all print!)
import 'package:sigma_track/core/utils/logging.dart';
// Use: this.logInfo|logError|logData|logDomain|logPresentation|logService
// Example: this.logService('Process started'); this.logError('Failed', e, s);

// 4) Comments (Better Comments format)
// TODO: | FIXME: | ! warning | ? question | * important note

// 5) const everywhere possible
// const SizedBox(height: 16), const Duration(milliseconds: 300)

// 6) Response: brief & to the point
// Only mention what changed/added/removed, no lengthy explanations

// 7) Docs: NO .md files unless explicitly requested
// Keep inline comments 1-2 lines max, code should be self-explanatory

// 8) Terminal: use modern CLI tools
// Files: eza, fd, rg, bat, sd | Git: lazygit, gh, delta
// Nav: z (zoxide), fzf, yazi | Dev: glow, jq, tldr, micro
// Monitor: btm, procs, dust, duf
// ❌ Avoid: dir, findstr, find, grep, cat, manual cd

// Quick examples:
Widget build(BuildContext context) => Container(
  color: context.colors.surface,
  child: Text(context.l10n.ok, style: context.textTheme.bodyMedium),
);

// Terminal workflows:
// fd -e dart | rg "TODO"  // find TODOs
// eza --tree -L 3 lib/    // show structure
// z sigma                 // jump to project
// lazygit                 // interactive git
