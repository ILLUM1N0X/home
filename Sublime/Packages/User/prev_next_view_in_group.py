import sublime, sublime_plugin


class PrevNextViewInGroupCommand(sublime_plugin.WindowCommand):
    def run(self, dir):
        w = sublime.active_window()
        group_views = w.views_in_group(w.active_group())
        views_count = len(group_views)

        curr_view = w.active_view()
        curr_view_index = w.get_view_index(curr_view)[1]

        next_view = group_views[(curr_view_index + dir) % views_count]
        w.focus_view(next_view)
