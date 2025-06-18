from lxml import etree
from pathlib import Path

INPUT_FILE = "CoraProjects.setup"
OUTPUT_DIR = Path("projects")
SETUP_NS = "http://www.eclipse.org/oomph/setup/1.0"
XSI_NS = "http://www.w3.org/2001/XMLSchema-instance"

NSMAP = {
    "setup": SETUP_NS,
    "xsi": XSI_NS
}

SCHEMA_LOC = (
    f"{SETUP_NS} https://raw.githubusercontent.com/eclipse-oomph/oomph/master/setups/models/Setup.ecore"
)

def find_projects_compound_task(root):
    for el in root.xpath(".//setup:setupTask[@name='Projects']", namespaces=NSMAP):
        xsi_type = el.attrib.get(f"{{{XSI_NS}}}type")
        if xsi_type == "setup:CompoundTask":
            return el
    return None

def create_compound_task_file(name, child):
    compound_task = etree.Element(
        f"{{{SETUP_NS}}}CompoundTask",
        nsmap=NSMAP
    )
    compound_task.set(f"{{{XSI_NS}}}type", "setup:CompoundTask")
    compound_task.set("name", name)
    compound_task.set(f"{{{XSI_NS}}}schemaLocation", SCHEMA_LOC)

    for task in list(child):
        compound_task.append(task)

    file_path = OUTPUT_DIR / f"{name}.setup"
    with open(file_path, "wb") as f:
        f.write(etree.tostring(compound_task, xml_declaration=True, encoding="UTF-8", pretty_print=True))
    print(f"✔ Created: {file_path}")

def main():
    tree = etree.parse(INPUT_FILE)
    root = tree.getroot()
    OUTPUT_DIR.mkdir(exist_ok=True)

    projects_task = find_projects_compound_task(root)
    if projects_task is None:
        print("❌ No 'Projects' CompoundTask found.")
        return

    new_imports = []

    for child in list(projects_task):
        name = child.get("name")
        xsi_type = child.attrib.get(f"{{{XSI_NS}}}type")
        if xsi_type != "setup:CompoundTask" or not name:
            continue

        create_compound_task_file(name, child)

        import_task = etree.Element(f"{{{SETUP_NS}}}setupTask", nsmap=NSMAP)
        import_task.set(f"{{{XSI_NS}}}type", "setup:SetupImportTask")
        import_task.set("url", f"projects/{name}.setup")

        # Ensure it gets a tail newline
        import_task.tail = "\n  "
        new_imports.append(import_task)
        projects_task.remove(child)

    # Add import tasks with line breaks
    for task in new_imports:
        projects_task.append(task)

    # Write updated file
    updated_file = "CoraProjects-modular.setup"
    with open(updated_file, "wb") as f:
        f.write(etree.tostring(tree, pretty_print=True, xml_declaration=True, encoding="UTF-8"))
        print(f"✅ Updated main setup written to: {updated_file}")

if __name__ == "__main__":
    main()
