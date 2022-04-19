#!/bin/bash

ItemGroup='  <ItemGroup>
    <Reference Include="Ink">
      <HintPath>$(ProjectDir)/ink-engine-runtime.dll</HintPath>
      <Private>False</Private>
    </Reference>
  </ItemGroup>
</Project>'

if [ "$#" -lt 1 ];
then
    echo "Usage: $0 <project directory>" > /dev/stderr
    exit 1
fi

projectPath=$(realpath $1)

until [ $(ls -l "$projectPath" | grep csproj | wc -l) -gt 0 ]
do
    echo "Create the C# Solution (Project->Tools->Mono->Create C# Solution) and press Enter to continue..."
    head -n 1 >/dev/null
done

echo "Checking if we need to download files from inkle's repository..."
inkFiles=("ink-engine-runtime.dll" "ink_compiler.dll" "inklecate.exe")
if [ -f "$projectPath/${inkFiles[0]}" -a -f "$projectPath/${inkFiles[1]}" -a -f "$projectPath/${inkFiles[2]}" ];
then
    echo "No."
else
    echo "Downloading archive from inkle's repository..."
    tmpDir=$(mktemp -d)
    curl -o "$tmpDir/ink.zip" -L "https://github.com/inkle/ink/releases/download/v1.0.0/inklecate_linux.zip" &> /dev/null
    for file in "${inkFiles[@]}"
    do
        unzip -j "$tmpDir/ink.zip" "$file" -d "$projectPath" > /dev/null
    done
    rm -rf "$tmpDir"
fi

echo ""

echo "Checking if we need to patch the .csproj file..."
csProjFile=$(find "$projectPath" -name "*.csproj")
if grep "ink-engine-runtime.dll" "$csProjFile" > /dev/null
then
    echo "No."
else
    echo "Patching $csProjFile..."
    gawk -v GROUP="$ItemGroup" -i inplace '{gsub(/<\/Project>/, GROUP)}; { print }' "$csProjFile"
fi

echo ""
echo "All done. Enjoy :)"
