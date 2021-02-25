# Registry Management

## Clean old tags

**Get registry ID**

    curl -sNH "Private-Token: TOKEN_WITH_FULL_API_SCOPE" "https://gitlab.blabla.net/api/v4/projects/PROJET_ID/registry/repositories"

**Remove all but the last 5 tags**

    curl --request DELETE --data 'name_regex_delete=.*' --data 'keep_n=5' --header "Private-Token: TOKEN_WITH_FULL_API_SCOPE" "https://gitlab.blabla.net/api/v4/projects/PROJET_ID/registry/repositories/REPO_ID/tags"
