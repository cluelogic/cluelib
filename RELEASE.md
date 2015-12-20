##Release Notes

###v0.4.0
- Added `tree`, `tree_node`, `tree_breadth_first_iterator`, `decimal_min_formatter`, and `hex_min_formatter` classes.
- Fixed a bug in `collection::contains`.
- Changed `collection::size` from `pure virtual` to `virtual` and added default implementation using an iterator.

###v0.3.0
- Added `network` class.
- The `journal` class no longer opens the log files (`journal.log` and
  `journal.csv`) by default. It is now user's responsibility to open the
  files. As a consequence, the macros (`CL_NAME_OF_LOG` and `CL_NAME_OF_CSV`)
  are obsolete.
- DPI-C is disabled by default (`cl_define.svh`).
- Fixed a bug in `crc::crc`.
- Fixed a bug in `data_stream::separated`.

###v0.2.0
- Added `journal::csv` function to store a transaction in the CSV (comma
  separated value) format.
- Added `CL_NAME_OF_CSV` macro to define the name of a CSV file used by the
  *journal* class.
- Renamed `CL_NAME_OF_JOURNAL` macro to `CL_NAME_OF_LOG`.

###v0.1.0
- Initial public release