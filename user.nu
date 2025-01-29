
export def relative_to_home [] {
    let p = $in
    match (do --ignore-shell-errors { $p | path relative-to $nu.home-path }) {
        null => $p
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }
}

def branch_prompt [] {
    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let colored_sep = $"($separator_color)(char path_sep)"

    def color_path [] {
        $"($path_color)($in)" | str replace --all (char path_sep) $"($colored_sep)($path_color)"
    }

    mut dir = $env.PWD | relative_to_home

    let branch_response = git branch --show-current | complete
    if $branch_response.exit_code == 0 {
        let branch = $branch_response.stdout | lines | get 0
        let repo_root = ^git rev-parse --show-toplevel | complete | get stdout | str trim | relative_to_home
        let repo_parent = $repo_root | path dirname
        let repo_name = ^basename $repo_root
        let path_relative_to_repo = match ($dir | path relative-to $repo_root) {
            "" => "",
            $relative => $"(char path_sep)($relative)(ansi reset)"
        }

        # add a link to the repo if we have one
        let repo_name_with_link = match (^git config --get remote.origin.url | complete | get stdout | str trim) {
            $url => ($url | ansi link --text $repo_name),
            "" => $repo_name,
        }

        let no_changes = (git diff-index --quiet HEAD -- | complete | get exit_code) == 0
        let unpushed = (git log --branches --not --remotes --max-count=1 | lines | length) > 0
        let unpulled = (git log --remotes --not --branches --max-count=1 | lines | length) > 0
        let staged = (git diff --staged --quiet | complete | get exit_code) == 1

        # remote tracking branchgit
        let unpushed_mark = if $unpushed { $"(ansi purple)↑(ansi reset)" } else { "" }
        let unpulled_mark = if $unpulled { $"(ansi red)↓(ansi reset)" } else { "" }
        let staged_mark = if $staged { $"(ansi yellow)●(ansi reset)" } else { "" }
        let color = if $no_changes { ansi grey } else { ansi xterm_gold3b }

        # example: "(main↑↓●)"
        let branch_info = $"(ansi grey)\((ansi reset)($color)($branch)(ansi reset)($unpushed_mark)($unpulled_mark)($staged_mark)(ansi grey)\)(ansi reset)"

        # build the prompt, example: "~/some/path/repo(main↑↓●)/src"
        $"($repo_parent | color_path)($colored_sep)($path_color)($repo_name_with_link)($branch_info)($path_relative_to_repo | color_path)"
    } else {
        $dir | color_path
    }
}


export def --env present [] {
    $env.PROMPT_COMMAND = {|| branch_prompt }
    print $"  (ansi green_bold)Luca Ciucci(ansi reset) <(ansi blue)luca.ciucci99@gmail.com(ansi reset)> <https://lucaciucci.github.io/>"
}

export def --env present-bugseng [] {
    $env.PROMPT_COMMAND = {|| branch_prompt }
    print $"  (ansi green_bold)Luca Ciucci @ Bugseng(ansi reset) <(ansi blue)luca.ciucci@bugseng.com(ansi reset)> <https://bugseng.com/>"
}

# Create a symlink
export def symlink [
    existing: path   # The existing file
    link_name: path  # The name of the symlink
] {
    # from the cookbook: https://www.nushell.sh/blog/2023-08-23-happy-birthday-nushell-4.html#crossplatform-symlinks-kubouch

    let existing = ($existing | path expand -s)
    let link_name = ($link_name | path expand)

    if $nu.os-info.family == 'windows' {
        if ($existing | path type) == 'dir' {
            ^mklink /D $link_name $existing
        } else {
            ^mklink $link_name $existing
        }
    } else {
        ^ln -s $existing $link_name | ignore
    }
}

# Explain the command using explainshell.com
export def explain [
    ...args
] {
    let command = $args | str join " " | str trim

    let url_arg = $command
        | str replace "%" "%25"
        | str replace " " "%20"
        | str replace "&" "%26"
        | str replace "|" "%7C"
        | str replace ";" "%3B"
        | str replace "(" "%28"
        | str replace ")" "%29"
        | str replace "{" "%7B"
        | str replace "}" "%7D"
        | str replace "[" "%5B"
        | str replace "]" "%5D"
        | str replace "<" "%3C"
        | str replace ">" "%3E"
        | str replace "#" "%23"
        | str replace "@" "%40"
        | str replace "$" "%24"
        | str replace "^" "%5E"
        | str replace "`" "%60"
        | str replace "\"" "%22"
        | str replace "'" "%27"
        | str replace "\\" "%5C"
        | str replace "/" "%2F"
        | str replace ":" "%3A"
        | str replace "=" "%3D"
        | str replace "?" "%3F"
        | str replace "!" "%21"
        | str replace "+" "%2B"
        | str replace "," "%2C"
        | str replace "." "%2E"
        | str replace "~" "%7E"

    let url = "https://explainshell.com/explain?cmd=" + $url_arg

    start $url
}