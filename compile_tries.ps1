# Define the base directory
$baseDir = "dictionaries"

# Get all subdirectories in the base directory
Get-ChildItem -Path $baseDir -Directory -Recurse | ForEach-Object {
    $subDir = $_.FullName

    # Find the first .trie file in the current subdirectory
    $trieFile = Get-ChildItem -Path $subDir -Filter *.trie -File | Select-Object -First 1

    if ($trieFile) {
        # Define the dict subdirectory and output file
        $dictDir = Join-Path $subDir "dict"
        $outputFile = Join-Path $dictDir "gen.txt"

        # Skip if output file already exists
        if (Test-Path -Path $outputFile) {
            Write-Host "Skipping $subDir - Output already exists."
            return
        }

        # Create the 'dict' directory if it doesn't exist
        if (-not (Test-Path -Path $dictDir)) {
            New-Item -Path $dictDir -ItemType Directory | Out-Null
        }

        # Run cspell-trie
        Write-Host "Processing $($trieFile.FullName) -> $outputFile"
        cspell-trie reader $trieFile.FullName > $outputFile
    }
}
