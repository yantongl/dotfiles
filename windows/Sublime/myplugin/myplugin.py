"""
My own commands.

To use custom plugin, it need to be in one of these two places:
1. Plugin folder must be under "Packages".
2. if it is a single script, it can be under "User". Though not recommmend to do this.

Command can be run in Sublime console (Ctrl+`) as:
view.run_command('example')
view.run_command('p4_checkout')
view.run_command('open_by_system')


"""

import sublime
import sublime_plugin
import subprocess
import os
import time


class ExampleCommand(sublime_plugin.TextCommand):
    """
    default plugin template.

    I use this to test if a command file is loaded correctly.
    """

    def run(self, edit):
        """."""
        self.view.insert(edit, 0, "Hello, World!")


class Markdown2HtmlCommand(sublime_plugin.TextCommand):
    """
    default plugin template.

    I use this to test if a command file is loaded correctly.
    """

    def run(self, edit):
        """."""
        filepath = self.view.file_name()
        htmlFilepath = filepath[0 : filepath.rfind(".")] + ".html"
        print("Converting {} to {}.".format(filepath, htmlFilepath))

        # get file name
        with open(htmlFilepath, "w") as outfile:
            result = subprocess.call(
                ["python", "-m", "markdown", filepath], stdout=outfile
            )
            if result != 0:
                sublime.error_message(
                    "Failed to convert file {} to HTML.".format(filepath)
                )
            else:
                print("success")


class mdBoldCommand(sublime_plugin.TextCommand):
    """Make selected text bold as Markdown file type."""

    def run(self, edit):
        """."""
        for region in self.view.sel():
            if not region.empty():
                # get the selected text
                s = self.view.substr(region)
                stripped_s = s.strip()
                # toggle boldness
                if stripped_s.startswith("*") and stripped_s.endswith("*"):
                    t = stripped_s[1:-1]
                else:
                    t = "*" + s + "*"
                    if region.begin() > 0:
                        lastChar = self.view.substr(region.begin() - 1)
                        if lastChar not in [" ", "\r", "\n"]:
                            t = " " + t
                    if (
                        region.end() < self.view.size()
                        and self.view.substr(region.end() + 1) != " "
                    ):
                        t = t + " "
                # replace
                self.view.replace(edit, region, t)


class P4CheckoutCommand(sublime_plugin.TextCommand):
    """."""

    def run(self, edit):
        """."""
        filepath = self.view.file_name()
        print("checking out file: " + filepath)

        # get file name
        result = subprocess.call(["p4", "edit", filepath])
        print("return code is: " + str(result))
        if result != 0:
            sublime.error_message("Failed to check out file: " + filepath)


class OpenBySystemCommand(sublime_plugin.TextCommand):
    """."""

    def run(self, edit):
        """."""
        hasSelectedText = False
        for region in self.view.sel():
            if not region.empty():
                # get the selected text
                s = self.view.substr(region)
                stripped_s = s.strip()
                if stripped_s:
                    print("open by system tool: " + stripped_s)
                    os.startfile(stripped_s)
                    hasSelectedText = False

        # get file name
        if not hasSelectedText:
            filepath = self.view.file_name()
            if filepath:
                filepath.replace("\\", "/")
                print("open by system tool: " + filepath)
                os.startfile(filepath)
        # result = subprocess.call(['START', filepath])
        # print("return code is: " + str(result))
        # if (result != 0):
        #     sublime.error_message("Failed to open file: "+filepath)

class OpenInNvimqtCommand(sublime_plugin.TextCommand):
    """."""

    def run(self, edit):
        """."""
        filepath = self.view.file_name()

        # get file name
        subprocess.Popen(["nvim-qt", filepath], shell=True)


class InsertDateCommand(sublime_plugin.TextCommand):
    """."""

    def run(self, edit):
        """."""
        sel = self.view.sel()
        for s in sel:
            if s.empty():
                self.view.insert(edit, s.begin(), time.strftime("%Y-%m-%d %a"))
            else:
                self.view.replace(edit, s, time.strftime("%Y-%m-%d %a"))
