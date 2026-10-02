# Backup & Recovery Lab

A hands-on lab demonstrating full, incremental, and differential backup strategies with restore validation, integrity checks, and RPO/RTO planning based on the 3-2-1 backup principle.

![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat&logo=linux&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

## Overview

This project provides four Bash scripts that cover the complete backup lifecycle: creation, verification, and restoration. It was built to practice real-world data protection scenarios, including simulated failures (full disk, permission issues, interrupted backups) and recovery validation.

## Architecture

```
                Source Data (any directory)
                         |
       +-----------------+-----------------+
       |                 |                 |
       v                 v                 v
  full_backup.sh   incremental_      backup_verify.sh
                   backup.sh
       |                 |                 |
       +-----------------+-----------------+
                         |
                         v
                 ./backups/ (archive
                 or snapshot history)
                         |
                         v
                   restore.sh  -->  Restored files
```

## Tech Stack

- **Shell:** Bash
- **Tools:** tar, gzip, rsync, find
- **OS:** Linux (Ubuntu), portable to macOS and Windows Git Bash

## Features

- Full backup using tar.gz compression
- Incremental backup using rsync with hardlink-based snapshots
- Restore from archive with destination control
- Archive integrity verification with entry listing
- Simulated failure scenarios (disk full, permissions, interrupted jobs)
- RPO/RTO-aware backup design principles

## Backup Strategy Concepts

| Backup Type | Description | Storage Cost | Recovery Speed |
|-------------|-------------|--------------|----------------|
| Full | Complete copy of all data | Highest | Fastest |
| Incremental | Only changes since last backup | Lowest | Slowest (needs chain) |
| Differential | Changes since last full backup | Medium | Medium |

**3-2-1 Principle:** Keep 3 copies of data, on 2 different media, with 1 copy off-site.

## Project Structure

```
backup-recovery-lab/
├── README.md
├── LICENSE
├── .gitignore
├── scripts/
│   ├── full_backup.sh           # tar.gz full backup
│   ├── incremental_backup.sh    # rsync snapshot backup
│   ├── restore.sh               # restore from archive
│   └── backup_verify.sh         # archive integrity check
├── docs/
└── screenshots/
```

## Setup

```bash
git clone https://github.com/Vinith145/backup-recovery-lab.git
cd backup-recovery-lab
chmod +x scripts/*.sh
```

## Usage

```bash
# Create test data
mkdir -p testdata && echo "hello backup" > testdata/file1.txt

# Full backup
./scripts/full_backup.sh testdata ./backups

# Verify integrity
./scripts/backup_verify.sh ./backups/full_backup_*.tar.gz

# Restore
./scripts/restore.sh ./backups/full_backup_*.tar.gz ./restored

# Incremental backup
./scripts/incremental_backup.sh testdata ./backups/incremental
```

## Sample Output

### full_backup.sh

```
==========================================
 Full Backup
==========================================
 Source:      testdata
 Destination: ./backups/full_backup_20261002_194500.tar.gz
 Started:     2026-10-02 19:45:00
==========================================
[OK] Full backup complete
[OK] Size: 4.0K
[OK] File: ./backups/full_backup_20261002_194500.tar.gz
==========================================
```

### backup_verify.sh

```
==========================================
 Backup Verification
==========================================
 Archive: ./backups/full_backup_20261002_194500.tar.gz
==========================================
[OK]   Archive is valid
[INFO] Size: 4.0K
[INFO] Entries: 2
```

## What I Learned

- Designing backup strategies based on RPO/RTO requirements
- Automating backup, verification, and restore workflows
- Applying the 3-2-1 backup principle in real scenarios
- Handling simulated failures: disk capacity, permissions, interrupted jobs
- Using rsync hardlinks for space-efficient snapshots

## Future Improvements

- Add S3 / cloud storage as backup target
- Schedule backups with cron or systemd timers
- Encrypt archives with GPG
- Add retention policy automation (delete old backups)
- Implement email/Slack alerts on backup failure

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.