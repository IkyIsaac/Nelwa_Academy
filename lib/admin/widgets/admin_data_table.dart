import 'package:flutter/material.dart';

import '../design/admin_tokens.dart';

class AdminColumn<T> {
  const AdminColumn({
    required this.label,
    required this.cellBuilder,
    this.flex = 2,
    this.numeric = false,
  });

  final String label;
  final Widget Function(BuildContext context, T item) cellBuilder;
  final int flex;

  /// Right-aligned, set in the mono figure face — for prices, counts, dates.
  final bool numeric;
}

/// Shared paginated, searchable table for every admin list page. Filtering
/// and pagination happen client-side over whatever the caller's Firestore
/// stream already returned — these collections aren't large enough yet to
/// need server-side search, and there's no search index (Algolia, etc.)
/// wired up regardless.
class AdminDataTable<T> extends StatefulWidget {
  const AdminDataTable({
    super.key,
    required this.itemsStream,
    required this.columns,
    this.statusOf,
    this.onTap,
    this.searchFilter,
    this.searchHint = 'Search…',
    this.trailing,
    this.pageSize = 20,
    this.emptyLabel = 'Nothing here yet.',
  });

  final Stream<List<T>> itemsStream;
  final List<AdminColumn<T>> columns;
  final AdminStatus Function(T item)? statusOf;
  final void Function(T item)? onTap;
  final bool Function(T item, String query)? searchFilter;
  final String searchHint;
  final Widget? trailing;
  final int pageSize;
  final String emptyLabel;

  @override
  State<AdminDataTable<T>> createState() => _AdminDataTableState<T>();
}

class _AdminDataTableState<T> extends State<AdminDataTable<T>> {
  String _query = '';
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<T>>(
      stream: widget.itemsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Error loading data: ${snapshot.error}',
            style: AdminType.body(13, color: AdminColors.error),
          );
        }
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final all = snapshot.data!;
        final filtered = widget.searchFilter == null || _query.isEmpty
            ? all
            : all.where((item) => widget.searchFilter!(item, _query)).toList();

        final pageCount =
            filtered.isEmpty ? 1 : ((filtered.length - 1) ~/ widget.pageSize) + 1;
        final page = _page < 0 ? 0 : (_page > pageCount - 1 ? pageCount - 1 : _page);
        final start = page * widget.pageSize;
        final endRaw = start + widget.pageSize;
        final end = endRaw > filtered.length ? filtered.length : endRaw;
        final pageItems = filtered.isEmpty ? <T>[] : filtered.sublist(start, end);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (widget.searchFilter != null)
                  SizedBox(
                    width: 320,
                    child: TextField(
                      style: AdminType.body(13),
                      decoration: InputDecoration(
                        hintText: widget.searchHint,
                        hintStyle: AdminType.body(13, color: AdminColors.inkFaint),
                        prefixIcon: const Icon(Icons.search, size: 18, color: AdminColors.inkFaint),
                        isDense: true,
                        filled: true,
                        fillColor: AdminColors.surface,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: AdminSpace.md, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AdminRadius.sm),
                          borderSide: const BorderSide(color: AdminColors.hairline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AdminRadius.sm),
                          borderSide: const BorderSide(color: AdminColors.hairline),
                        ),
                      ),
                      onChanged: (value) => setState(() {
                        _query = value;
                        _page = 0;
                      }),
                    ),
                  ),
                const Spacer(),
                if (widget.trailing != null) widget.trailing!,
              ],
            ),
            const SizedBox(height: AdminSpace.lg),
            if (filtered.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 60),
                decoration: BoxDecoration(
                  color: AdminColors.surface,
                  borderRadius: BorderRadius.circular(AdminRadius.lg),
                  border: Border.all(color: AdminColors.hairline),
                ),
                child: Center(
                  child: Text(widget.emptyLabel, style: AdminType.body(13, color: AdminColors.inkFaint)),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: AdminColors.surface,
                  borderRadius: BorderRadius.circular(AdminRadius.lg),
                  border: Border.all(color: AdminColors.hairline),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _HeaderRow(columns: widget.columns, hasSpine: widget.statusOf != null),
                    for (final item in pageItems)
                      _BodyRow<T>(
                        item: item,
                        columns: widget.columns,
                        status: widget.statusOf?.call(item),
                        onTap: widget.onTap == null ? null : () => widget.onTap!(item),
                      ),
                  ],
                ),
              ),
            if (filtered.isNotEmpty) ...[
              const SizedBox(height: AdminSpace.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Showing ${start + 1}–$end of ${filtered.length}',
                    style: AdminType.mono(12, color: AdminColors.inkFaint),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20),
                    color: AdminColors.ink,
                    onPressed: page > 0 ? () => setState(() => _page = page - 1) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20),
                    color: AdminColors.ink,
                    onPressed:
                        page < pageCount - 1 ? () => setState(() => _page = page + 1) : null,
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _HeaderRow<T> extends StatelessWidget {
  const _HeaderRow({required this.columns, required this.hasSpine});

  final List<AdminColumn<T>> columns;
  final bool hasSpine;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AdminColors.canvas,
        border: Border(bottom: BorderSide(color: AdminColors.hairline)),
      ),
      padding: EdgeInsets.fromLTRB(
          hasSpine ? AdminSpace.lg + 3 : AdminSpace.lg, AdminSpace.md, AdminSpace.lg, AdminSpace.md),
      child: Row(
        children: [
          for (var i = 0; i < columns.length; i++) ...[
            Expanded(
              flex: columns[i].flex,
              child: Text(
                columns[i].label.toUpperCase(),
                textAlign: columns[i].numeric ? TextAlign.right : TextAlign.left,
                style: AdminType.eyebrow(),
              ),
            ),
            if (i != columns.length - 1) const SizedBox(width: AdminSpace.lg),
          ],
        ],
      ),
    );
  }
}

class _BodyRow<T> extends StatefulWidget {
  const _BodyRow({required this.item, required this.columns, this.status, this.onTap});

  final T item;
  final List<AdminColumn<T>> columns;
  final AdminStatus? status;
  final VoidCallback? onTap;

  @override
  State<_BodyRow<T>> createState() => _BodyRowState<T>();
}

class _BodyRowState<T> extends State<_BodyRow<T>> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final row = Container(
      decoration: BoxDecoration(
        color: _hovering ? AdminColors.canvas : AdminColors.surface,
        border: const Border(bottom: BorderSide(color: AdminColors.hairline)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AdminSpace.lg, vertical: AdminSpace.md),
      child: Row(
        children: [
          for (var i = 0; i < widget.columns.length; i++) ...[
            Expanded(
              flex: widget.columns[i].flex,
              child: Align(
                alignment: widget.columns[i].numeric ? Alignment.centerRight : Alignment.centerLeft,
                child: widget.columns[i].cellBuilder(context, widget.item),
              ),
            ),
            if (i != widget.columns.length - 1) const SizedBox(width: AdminSpace.lg),
          ],
        ],
      ),
    );

    final spined = widget.status == null
        ? row
        : StatusSpine(status: widget.status!, child: row);

    if (widget.onTap == null) return spined;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(onTap: widget.onTap, child: spined),
    );
  }
}

/// Standard cell text — most columns just need this.
class AdminCellText extends StatelessWidget {
  const AdminCellText(this.text, {super.key, this.mono = false, this.muted = false});

  final String text;
  final bool mono;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final color = muted ? AdminColors.inkFaint : AdminColors.ink;
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: mono ? AdminType.mono(13, color: color) : AdminType.body(13, color: color),
    );
  }
}
