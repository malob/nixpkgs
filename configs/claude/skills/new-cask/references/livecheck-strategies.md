# Livecheck Strategies Reference

Detailed patterns for configuring `livecheck` blocks in Homebrew casks.

## Strategy: `:header_match`

Use when the download URL is a `/latest` redirect that returns the actual version in the redirect location or filename.

**How it works**: Makes a HEAD request and extracts version from the `Location` header or `Content-Disposition` filename.

```ruby
# Basic - extracts version from redirect URL automatically
livecheck do
  url "https://example.com/download/latest"
  strategy :header_match
end

# With regex - when version format needs extraction
livecheck do
  url "https://example.com/download/latest"
  regex(/App[._-]v?(\d+(?:\.\d+)+)\.dmg/i)
  strategy :header_match
end

# With block - for complex version extraction
livecheck do
  url "https://example.com/download/latest"
  strategy :header_match do |headers|
    headers["location"][/v(\d+(?:\.\d+)+)/i, 1]
  end
end
```

**Architecture-specific livecheck**: When ARM and Intel have different version feeds:
```ruby
livecheck do
  url "https://example.com/#{arch}/latest"
  strategy :header_match
end
```

## Strategy: `:json`

Use when versions are published in a JSON feed (common for Electron apps with RELEASES.json).

```ruby
# Simple key access
livecheck do
  url "https://example.com/RELEASES.json"
  strategy :json do |json|
    json["version"]
  end
end

# Nested structure
livecheck do
  url "https://example.com/releases.json"
  strategy :json do |json|
    json["currentRelease"]
  end
end

# Array of releases - get latest
livecheck do
  url "https://example.com/api/releases"
  strategy :json do |json|
    json["releases"]&.first&.dig("version")
  end
end

# With regex filtering
livecheck do
  url "https://example.com/releases.json"
  regex(/^v?(\d+(?:\.\d+)+)$/i)
  strategy :json do |json, regex|
    json["versions"]&.map { |v| v["name"]&.[](regex, 1) }
  end
end
```

**Architecture-specific JSON feeds**:
```ruby
cask "example" do
  arch arm: "arm64", intel: "x64"

  # ... version/sha256 blocks ...

  livecheck do
    url "https://example.com/#{arch}/RELEASES.json"
    strategy :json do |json|
      json["currentRelease"]
    end
  end
end
```

## Strategy: `:github_latest`

Use for GitHub-hosted projects with proper releases. Preferred over `:git` when the repo uses GitHub's release feature.

```ruby
# Basic - uses stable URL's GitHub repo
livecheck do
  url :stable
  strategy :github_latest
end

# Explicit URL
livecheck do
  url "https://github.com/owner/repo"
  strategy :github_latest
end

# With regex for tag format
livecheck do
  url :stable
  regex(/^v?(\d+(?:\.\d+)+)$/i)
  strategy :github_latest
end

# With block for complex extraction
livecheck do
  url :stable
  strategy :github_latest do |json, regex|
    json["tag_name"]&.sub(/^v/, "")
  end
end
```

**Note**: GitHub rate-limits API requests. Only use when `:git` strategy is insufficient.

## Strategy: `:sparkle`

Use for apps that self-update via the Sparkle framework. Find the appcast URL in the app's Info.plist (`SUFeedURL` key).

```ruby
# Basic
livecheck do
  url "https://example.com/appcast.xml"
  strategy :sparkle
end

# Use short_version only
livecheck do
  url "https://example.com/appcast.xml"
  strategy :sparkle, &:short_version
end

# Use version only
livecheck do
  url "https://example.com/appcast.xml"
  strategy :sparkle, &:version
end

# Complex extraction
livecheck do
  url "https://example.com/appcast.xml"
  strategy :sparkle do |item|
    "#{item.short_version},#{item.version}"
  end
end
```

**Finding the appcast URL**:
```bash
brew find-appcast "/Applications/Example.app"
# Or manually:
defaults read "/Applications/Example.app/Contents/Info.plist" SUFeedURL
```

## Strategy: `:page_match`

Use when version must be scraped from an HTML page (download pages, changelogs).

```ruby
# Basic with regex
livecheck do
  url "https://example.com/downloads/"
  regex(/href=.*?example[._-]v?(\d+(?:\.\d+)+)\.dmg/i)
  strategy :page_match
end

# With block for complex extraction
livecheck do
  url "https://example.com/releases/"
  strategy :page_match do |page|
    page.scan(/Version (\d+(?:\.\d+)+)/i).flatten
  end
end

# Multiple captures combined
livecheck do
  url "https://example.com/download"
  regex(%r{/(\d+)/App-(\d+(?:\.\d+)+)\.zip}i)
  strategy :page_match do |page, regex|
    match = page.match(regex)
    next if match.blank?
    "#{match[2]},#{match[1]}"
  end
end
```

## Strategy: `:git`

Use for Git repositories when checking tags. Lower API overhead than GitHub strategies.

```ruby
# Basic - matches version tags
livecheck do
  url :stable
  regex(/^v?(\d+(?:\.\d+)+)$/i)
  strategy :git
end

# With prefix in tags
livecheck do
  url "https://github.com/owner/repo.git"
  regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  strategy :git
end
```

## Strategy: `:electron_builder`

Use for Electron apps with `latest-mac.yml` update feeds.

```ruby
livecheck do
  url "https://example.com/releases/latest-mac.yml"
  strategy :electron_builder
end

# With block
livecheck do
  url "https://example.com/latest-mac.yml"
  strategy :electron_builder do |yaml|
    yaml["version"]
  end
end
```

## Regex Best Practices

### Common patterns

```ruby
# Version number (1.2.3, 1.2.3.4, etc.)
/(\d+(?:\.\d+)+)/

# Version with optional 'v' prefix
/v?(\d+(?:\.\d+)+)/

# Anchored for exact match
/^v?(\d+(?:\.\d+)+)$/

# In filename
/App[._-]v?(\d+(?:\.\d+)+)\.dmg/i

# In href attribute
/href=.*?app[._-]v?(\d+(?:\.\d+)+)\.t/i
```

### Guidelines

1. **Case insensitive** - Add `i` flag: `/pattern/i`
2. **Non-capturing groups** - Use `(?:...)` for grouping without capture
3. **Flexible separators** - Use `[._-]` between name and version
4. **Tarball extension** - Use `\.t` to match any tarball format
5. **Anchor when possible** - `^` and `$` prevent partial matches

## Debugging Livecheck

```bash
# Full debug output
brew livecheck --debug --cask <name>

# Just check if it works
brew livecheck --cask <name>
```

Debug output shows:
- URLs being checked
- Strategies being tried
- Regex matches
- Extracted versions

## Skip Livecheck

For casks where automated version checking is impossible:

```ruby
livecheck do
  skip "No version information available online"
end
```

Use sparingly - most casks should have working livechecks.
