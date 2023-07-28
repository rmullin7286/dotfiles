import os

from ranger.api.commands import Command

class chezmoi_edit(Command):
    """:chezmoi_edit <filename>
    Edits the file through chezmoi, and automatically applies the changes
    """
    def execute(self):
        filename = self.arg(1) if self.arg(1) else self.fm.thisfile.path

        if not os.path.exists(filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        self.fm.execute_command(['chezmoi', 'edit', '--apply', filename])

class chezmoi_add(Command):
    """:chezmoi_add <filename>
    Adds a file for tracking with chezmoi
    """
    def execute(self):
        filename = self.arg(1) if self.arg(1) else self.fm.thisfile.path

        if not os.path.exists(filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        self.fm.execute_command(['chezmoi', 'add', filename])
