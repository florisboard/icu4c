cmake_minimum_required(VERSION 3.19)

file(READ ${ICU4C_CONFIG_JSON} configJson)

string(JSON ICU_GIT_REPO_URL GET ${configJson} "icu" "version" "git_repo_url")
string(JSON ICU_VERSION_MAJOR GET ${configJson} "icu" "version" "major")
string(JSON ICU_VERSION_MINOR GET ${configJson} "icu" "version" "minor")

message(FATAL ${configJson})
