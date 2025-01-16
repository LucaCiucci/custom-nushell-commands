def branch_prompt [] {
    let branch = do {
        let response = git branch --show-current | complete
        if $response.exit_code == 0 {
            let branch = $response.stdout | lines | get 0
            let no_changes = (git diff-index --quiet HEAD -- | complete | get exit_code) == 0
            let unpushed = (git log --branches --not --remotes --max-count=1 | lines | length) > 0
            let unpulled = (git log --remotes --not --branches --max-count=1 | lines | length) > 0
            let staged = (git diff --staged --quiet | complete | get exit_code) == 1
            let unpushed_mark = if $unpushed { $"(ansi purple)↑(ansi reset)" } else { "" }
            let unpulled_mark = if $unpulled { $"(ansi red)↓(ansi reset)" } else { "" }
            let staged_mark = if $staged { $"(ansi yellow)●(ansi reset)" } else { "" }
            let color = if $no_changes { ansi grey } else { ansi xterm_gold3b }
            $"(ansi grey)\((ansi reset)($color)($branch)(ansi reset)($unpushed_mark)($unpulled_mark)($staged_mark)(ansi grey)\)(ansi reset)"
        } else {
            ""
        }
    }

    $in + $branch
}


export def --env present [] {
    let default_prompt = $env.PROMPT_COMMAND
    $env.PROMPT_COMMAND = {|| do $default_prompt | branch_prompt }
    print $"  (ansi green_bold)Luca Ciucci(ansi reset) <(ansi blue)luca.ciucci99@gmail.com(ansi reset)> <https://lucaciucci.github.io/>"
}

export def --env present-bugseng [] {
    let default_prompt = $env.PROMPT_COMMAND
    $env.PROMPT_COMMAND = {|| do $default_prompt | branch_prompt }
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
