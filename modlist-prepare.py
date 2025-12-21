import requests
from typing import List, Dict, Optional

MODRINTH_API = "https://api.modrinth.com/v2"

MC_VERSION_CANDIDATES = [
    "1.21.1",
    "1.21",
    "1.21.0",
]

LOADER_CANDIDATES = [
    "neoforge",
    "forge",
]

# this can come from something like prism launcher
MODLIST = [
    {"name": "AppleSkin", "id": "EsAfCjCV", "version": "3.0.7"},
    {"name": "Architectury", "id": "lhGA9TYQ", "version": "13.0.8"},
    {"name": "Athena", "id": "b1ZV3DIJ", "version": "4.0.2"},
    {"name": "Backported Spears", "id": "rVUtrHuM", "version": "1.5.0"},
    {"name": "Balm", "id": "MBAkmtvl", "version": "21.0.55"},
    {"name": "BetterTrims", "id": "98ytUvlc", "version": "4.0.4"},
    {"name": "Biomes O' Plenty", "id": "HXF82T3G", "version": "21.1.0.13"},
    {"name": "Carry On", "id": "joEfVgkn", "version": "2.2.2"},
    {"name": "Cloth Config v15 API", "id": "9s6osm5g", "version": "15.0.140"},
    {"name": "Clumps", "id": "Wnxd13zP", "version": "19.0.0.1"},
    {"name": "Comforts", "id": "SaCpeal4", "version": "9.0.4"},
    {"name": "C2ME", "id": "COlSi5iR", "version": "0.3.0"},
    {"name": "Configurable", "id": "lGffrQ3O", "version": "3.3.2"},
    {"name": "Continuity", "id": "1IjD5062", "version": "3.0.0"},
    {"name": "Create", "id": "LNytGWDc", "version": "6.0.8"},
    {"name": "Create Crafts & Additions", "id": "kU1G12Nn", "version": "1.5.9"},
    {"name": "Create Deco", "id": "sMvUb4Rb", "version": "2.1.2"},
    {"name": "Create Hypertube", "id": "ATDdrG1y", "version": "0.3.0"},
    {"name": "Create Jetpack", "id": "UbFnAd4l", "version": "5.1.2"},
    {"name": "Create Stuff & Additions", "id": "aq9qUUQG", "version": "2.0.9"},
    {"name": "Create: Bells & Whistles", "id": "gJ5afkVv", "version": "0.4.7"},
    {"name": "Create: Central Kitchen", "id": "btq68HMO", "version": "2.2.6"},
    {"name": "Create: Copper and Zinc", "id": "aqYNR6rI", "version": "1.6.5"},
    {"name": "Create: Copycats+", "id": "UT2M39wf", "version": "3.0.4"},
    {"name": "Create: Dragons Plus", "id": "dzb1a5WV", "version": "1.8.5"},
    {"name": "Create: Enchantment Industry", "id": "JWGBpFUP", "version": "2.2.5"},
    {"name": "Create: Interiors", "id": "r4Knci2k", "version": "0.6.0"},
    {"name": "Create: Power Loader", "id": "wPQ6GgFE", "version": "2.0.3"},
    {"name": "Create: Renewable Diamonds", "id": "IxTis4hc", "version": "1.0.1"},
    {"name": "Create: Stones", "id": "KKlx33Ch", "version": "2.0.1"},
    {"name": "Cristel Lib", "id": "cl223EMc", "version": "3.0.2.1"},
    {"name": "Design n' Decor", "id": "x49wilh8", "version": "2.1.0"},
    {"name": "Do a Barrel Roll", "id": "6FtRfnLg", "version": "3.7.3"},
    {"name": "Dungeons and Taverns", "id": "tpehi7ww", "version": "4.4.4"},
    {"name": "EntityCulling", "id": "NNAgCjsB", "version": "1.9.4"},
    {"name": "Even Better Nether", "id": "ZSdhSrVt", "version": "1.3.0"},
    {"name": "FallingTree", "id": "Fb4jn8m6", "version": "1.21.1"},
    {"name": "Farmer's Delight", "id": "R2OftAxM", "version": "1.2.9"},
    {"name": "Ferrite Core", "id": "uXXizFIs", "version": "7.0.2"},
    {"name": "Forgified Fabric API", "id": "Aqlf1Shp", "version": "0.115.6"},
    {"name": "Formations", "id": "tPe4xnPd", "version": "1.0.4"},
    {"name": "Formations Nether", "id": "cGvQGRls", "version": "1.0.5"},
    {"name": "Friends&Foes", "id": "BOCJKD49", "version": "4.0.17"},
    {"name": "GeckoLib", "id": "8BmcQJ2H", "version": "4.8.2"},
    {"name": "GlitchCore", "id": "s3dmwKy5", "version": "2.1.0.0"},
    {"name": "Gravestone Mod", "id": "RYtXKJPr", "version": "1.0.35"},
    {"name": "Horse Expert", "id": "24CSPS1E", "version": "21.1.0"},
    {"name": "Horseman", "id": "qIv5FhAA", "version": "1.5.6"},
    {"name": "ImmediatelyFast", "id": "5ZwdcRci", "version": "1.6.9"},
    {"name": "Jade", "id": "nvQzSEkH", "version": "15.10.3"},
    {"name": "Just Enough Items", "id": "u6dRKJwZ", "version": "19.25.1"},
    {"name": "Kotlin for Forge", "id": "ordsPcFz", "version": "5.10.0"},
    {"name": "Lithosphere", "id": "iv9jp2k9", "version": "1.7"},
    {"name": "Lithostitched", "id": "XaDC71GB", "version": "1.5.4"},
    {"name": "Lootr", "id": "EltpO5cN", "version": "1.11.36"},
    {"name": "ModernFix", "id": "nmDcB62a", "version": "5.25.1"},
    {"name": "Mounts of Mayhem", "id": "3vLDJ86g", "version": "1.9.7"},
    {"name": "Nether Depths Upgrade", "id": "vI1QKJro", "version": "3.1.8"},
    {"name": "NetherPortalFix", "id": "nPZr02ET", "version": "21.1.1"},
    {"name": "NetherVillagerTrader", "id": "BmVw9C1J", "version": "2.0.0"},
    {"name": "Oritech", "id": "4sYI62kA", "version": "0.19.7"},
    {"name": "Puzzles Lib", "id": "QAGBst4M", "version": "21.1.39"},
    {"name": "Resourceful Lib", "id": "G1hIVOrD", "version": "3.0.12"},
    {"name": "Sinytra Connector", "id": "u58R1TMW", "version": "2.0.0"},
    {"name": "Sophisticated Backpacks", "id": "TyCTlI4b", "version": "3.25.19"},
    {"name": "Sophisticated Core", "id": "nmoqTijg", "version": "1.3.95"},
    {"name": "Stellarity", "id": "bZgeDzN8", "version": "3.0.6"},
    {"name": "Still Life", "id": "fK6aflho", "version": "0.1.1"},
    {"name": "Storage Drawers", "id": "guitPqEi", "version": "13.11.4"},
    {"name": "Storage Drawers Create Compat", "id": "c8JYP4m3", "version": "1.0.1"},
    {"name": "Tectonic", "id": "lWDHr9jE", "version": "3.0.17"},
    {"name": "TerraBlender", "id": "kkmrDlKT", "version": "4.1.0.8"},
    {"name": "Terralith", "id": "8oi3bsk5", "version": "2.5.8"},
    {"name": "Towns and Towers", "id": "DjLobEOy", "version": "1.13.7"},
    {"name": "Waystones", "id": "LOpKHB2A", "version": "21.1.25"},
    {"name": "Xaero's Minimap", "id": "1bokaNcj", "version": "25.2.10"},
    {"name": "Xaero's World Map", "id": "NcUtCpym", "version": "1.39.12"},
    {"name": "YUNG's API", "id": "Ua7DFN59", "version": "5.1.6"},
    {"name": "YUNG's Better Desert Temples", "id": "XNlO7sBv", "version": "4.1.5"},
    {"name": "YUNG's Better Dungeons", "id": "o1C1Dkj5", "version": "5.1.4"},
    {"name": "YUNG's Better Mineshafts", "id": "HjmxVlSr", "version": "5.1.1"},
    {"name": "YUNG's Better Nether Fortresses", "id": "Z2mXHnxP", "version": "3.1.5"},
    {"name": "YUNG's Better Ocean Monuments", "id": "3dT9sgt4", "version": "4.1.2"},
    {"name": "YUNG's Bridges", "id": "Ht4BfYp6", "version": "5.1.1"},
    {"name": "YetAnotherConfigLib", "id": "1eAoo2KR", "version": "3.8.1"},
    {"name": "[Let's Do] Farm & Charm", "id": "HJetCzWo", "version": "1.1.14"},
    {"name": "Create: Things and Misc", "id": "uWrs8XlB", "version": "4.0"},
    {"name": "owo-lib", "id": "ccKDOlHs", "version": "0.12.15"}
]

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

    # ideally this shouldnt be necessary if the initial feasibility is done correctly
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

    for mod in MODLIST:
        print(f"Resolving {mod}...")

        resolved = resolve_mod(mod["id"])
        if resolved:
            results.append(resolved)

    print("\nResolved mods:\n")
    print(f"TOTAL RESOLVED: {len(results)}")

    for r in results:
        print(f"- {r['project']}")
        print(f"  File:    {r['filename']}")
        print(f"  URL:     {r['download_url']}\n")

    with open('modlist.txt', "w") as f:
        for r in results:
            f.write(r['download_url']+"\n")

if __name__ == "__main__":
    main()
