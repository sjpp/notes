---
tags:
    - cli
    - vim
---

## Vim

* Remplacer un caractère par un retour à la ligne :

    Utiliser “ \r “ au lieu de ”\n".

Running a macro (http://vim.wikia.com/wiki/Macros)
Use this mapping as a convenient way to play a macro recorded to register q:

    :nnoremap <Space> @q

• Start recording keystrokes by typing qq.
• End recording with q (first press Escape if you are in insert mode).
• Play the recorded keystrokes by hitting space.
Suppose you have a macro which operates on the text in a single line. You can run the macro on each line in a visual selection in a single operation:
• Visually select some lines (for example, type vip to select the current paragraph).
• Type :normal @q to run the macro from register q on each line.

Vim has a very powerful built-in sort utility, or it can interface with an external one. In order to keep only unique lines in Vim, you would:

    :{range}sort u

* Remove all trailing spaces

    :%s/\s\+$//e

* Vimdiff local and remote files via ssh

    vimdiff /path/to/file scp://remotehost//path/to/file

