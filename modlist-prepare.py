import requests
from typing import List, Dict, Optional

MODLIST: List[str] = []
with open('input.txt', 'r') as f: # export ONLY the urls from prism, separated by \n
    MODLIST = f.read().splitlines()

# subject to change
MODRINTH_API = "https://api.modrinth.com/v2"

# change as required
MC_VERSION_CANDIDATES = [
    "1.21.1",
    "1.21",
    "1.21.0",
]

# change as required
LOADER_CANDIDATES = [
    "neoforge",
    "forge",
]

# these are essentially our targets
MODLOADER = "neoforge"
MC_VERSION = "1.21.1"

def get_project_versions(
    project_id_or_slug: str,
    mc_version: str,
    loader: str,
) -> List[Dict]:
    url = f"{MODRINTH_API}/project/{project_id_or_slug}/version"
    params = {
        "game_versions": f'["{mc_version}"]',
        "loaders": f'["{loader}"]',
    }

    try:
        resp = requests.get(url, params=params, timeout=15)
        # resp wont exist for a 404

        resp.raise_for_status()
        return resp.json()

    except Exception as e:
        print(f"[ERROR] {project_id_or_slug} ({loader}, {mc_version}): {e}")
        return []
    

def select_download_file(version: Dict) -> Optional[Dict]:
    """
    Pick the best file from a version:
    - prefer primary file
    - otherwise first file
    """
    files = version.get("files", [])
    if not files:
        return None

    for f in files:
        if f.get("primary"):
            return f

    return files[0]


def resolve_mod(project_slug: str) -> Optional[Dict]:

    # ideally this shouldnt be necessary if the initial feasibility is done correctly. 
    # feasibility here means the compabitility is checked. if prism can pull this mod, we also can
    for loader in LOADER_CANDIDATES:
        for mc_version in MC_VERSION_CANDIDATES:
            versions = get_project_versions(
                project_slug,
                mc_version,
                loader,
            )

            if not versions:
                continue

            version = versions[0]
            file = select_download_file(version)

            if not file:
                continue

            if loader != MODLOADER or mc_version != MC_VERSION:
                print(
                    f"[INFO] {project_slug}: "
                    f"using fallback loader={loader}, mc={mc_version}"
                )

            return {
                "project": project_slug,
                "filename": file.get("filename"),
                "download_url": file.get("url"),
            }

    print(f"[WARN] No compatible versions found for {project_slug}")
    return None


def main():
    results = []

    for item in MODLIST:
        mod = item.strip().split("https://modrinth.com/mod/")[1] # very delicate

        print(f"Resolving {mod}...")

        resolved = resolve_mod(mod)
        if resolved:
            results.append(resolved)

    print(f"TOTAL RESOLVED: {len(results)}\n")

    for r in results:
        print(f"- {r['project']}")
        print(f"  File:    {r['filename']}")

    with open('output.txt', "w") as f:
        for r in results:
            f.write(r['download_url']+"\n")

if __name__ == "__main__":
    main()
