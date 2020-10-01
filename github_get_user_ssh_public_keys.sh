#!/usr/bin/env bash
#
#  Author: Hari Sekhon
#  Date: 2019-09-18
#
#  https://github.com/harisekhon/devops-bash-tools
#
#  License: see accompanying LICENSE file
#
#  https://www.linkedin.com/in/harisekhon
#

# https://docs.github.com/en/rest/reference/users#list-public-keys-for-a-user

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
#srcdir="$(dirname "${BASH_SOURCE[0]}")"

usage(){
    cat <<EOF
Fetches a GitHub user's public SSH key(s) via the GitHub API

User can be given as first argument, otherwise falls back to using environment variables \$GITHUB_USER or \$USER

${0##*/} <user>
EOF
    exit 3
}

for arg; do
    case "$arg" in
        -*)     usage
                ;;
    esac
done

if [ $# -gt 1 ]; then
    usage
elif [ $# -eq 1 ]; then
    user="$1"
elif [ -n "${GITHUB_USER:-}" ]; then
    user="$GITHUB_USER"
elif [ -n "${USER:-}" ]; then
    if [[ "$USER" =~ hari|sekhon ]]; then
        user=harisekhon
    else
        user="$USER"
    fi
else
    usage
fi

# XXX: not handling paging because if you have > 100 SSH keys I want to know what is going on first!

echo "# Fetching SSH Public Key(s) from GitHub for account:  $user" >&2
echo "#" >&2
#if [ "$user" = "${GITHUB_USER:-}" ]; then
#    # authenticated query for simpler endpoint with more information doesn't work
#    # gets 404 even though /user works and is clearly authenticated - are the API docs wrong?
#    "$srcdir/github_api.sh" "/user/keys" -H "Accept: application/vnd.github.v3+json" |
    #"$srcdir/github_api.sh" "/users/$user/keys" |
    #jq -r '.[].id' |
    #while read -r id; do
    #    # also gets 404, or 401 if trying curl without github_api.sh handling the auth
    #    "$srcdir/github_api.sh" "/user/keys/$id" |
    #    jq .
    #done
#else
    curl -sS --fail "https://api.github.com/users/$user/keys" |
#fi |
jq -r '.[].key'
