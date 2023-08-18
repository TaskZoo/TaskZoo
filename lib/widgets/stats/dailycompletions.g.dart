// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dailycompletions.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyCompletionEntryCollection on Isar {
  IsarCollection<DailyCompletionEntry> get dailyCompletionEntrys =>
      this.collection();
}

const DailyCompletionEntrySchema = CollectionSchema(
  name: r'DailyCompletionEntry',
  id: 3026452617232975217,
  properties: {
    r'completionCount': PropertySchema(
      id: 0,
      name: r'completionCount',
      type: IsarType.long,
    ),
    r'completionPercent': PropertySchema(
      id: 1,
      name: r'completionPercent',
      type: IsarType.double,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.string,
    )
  },
  estimateSize: _dailyCompletionEntryEstimateSize,
  serialize: _dailyCompletionEntrySerialize,
  deserialize: _dailyCompletionEntryDeserialize,
  deserializeProp: _dailyCompletionEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dailyCompletionEntryGetId,
  getLinks: _dailyCompletionEntryGetLinks,
  attach: _dailyCompletionEntryAttach,
  version: '3.1.0+1',
);

int _dailyCompletionEntryEstimateSize(
  DailyCompletionEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.date.length * 3;
  return bytesCount;
}

void _dailyCompletionEntrySerialize(
  DailyCompletionEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.completionCount);
  writer.writeDouble(offsets[1], object.completionPercent);
  writer.writeString(offsets[2], object.date);
}

DailyCompletionEntry _dailyCompletionEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyCompletionEntry(
    completionCount: reader.readLong(offsets[0]),
    completionPercent: reader.readDouble(offsets[1]),
    date: reader.readString(offsets[2]),
    id: id,
  );
  return object;
}

P _dailyCompletionEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyCompletionEntryGetId(DailyCompletionEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyCompletionEntryGetLinks(
    DailyCompletionEntry object) {
  return [];
}

void _dailyCompletionEntryAttach(
    IsarCollection<dynamic> col, Id id, DailyCompletionEntry object) {
  object.id = id;
}

extension DailyCompletionEntryQueryWhereSort
    on QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QWhere> {
  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DailyCompletionEntryQueryWhere
    on QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QWhereClause> {
  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterWhereClause>
      dateEqualTo(String date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterWhereClause>
      dateNotEqualTo(String date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DailyCompletionEntryQueryFilter on QueryBuilder<DailyCompletionEntry,
    DailyCompletionEntry, QFilterCondition> {
  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> completionCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> completionCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> completionCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> completionCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completionCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> completionPercentEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completionPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> completionPercentGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completionPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> completionPercentLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completionPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> completionPercentBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completionPercent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> dateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> dateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> dateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> dateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
          QAfterFilterCondition>
      dateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
          QAfterFilterCondition>
      dateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyCompletionEntryQueryObject on QueryBuilder<DailyCompletionEntry,
    DailyCompletionEntry, QFilterCondition> {}

extension DailyCompletionEntryQueryLinks on QueryBuilder<DailyCompletionEntry,
    DailyCompletionEntry, QFilterCondition> {}

extension DailyCompletionEntryQuerySortBy
    on QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QSortBy> {
  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterSortBy>
      sortByCompletionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionCount', Sort.asc);
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterSortBy>
      sortByCompletionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionCount', Sort.desc);
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterSortBy>
      sortByCompletionPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionPercent', Sort.asc);
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterSortBy>
      sortByCompletionPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionPercent', Sort.desc);
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }
}

extension DailyCompletionEntryQuerySortThenBy
    on QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QSortThenBy> {
  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterSortBy>
      thenByCompletionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionCount', Sort.asc);
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterSortBy>
      thenByCompletionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionCount', Sort.desc);
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterSortBy>
      thenByCompletionPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionPercent', Sort.asc);
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterSortBy>
      thenByCompletionPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionPercent', Sort.desc);
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DailyCompletionEntryQueryWhereDistinct
    on QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QDistinct> {
  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QDistinct>
      distinctByCompletionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completionCount');
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QDistinct>
      distinctByCompletionPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completionPercent');
    });
  }

  QueryBuilder<DailyCompletionEntry, DailyCompletionEntry, QDistinct>
      distinctByDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }
}

extension DailyCompletionEntryQueryProperty on QueryBuilder<
    DailyCompletionEntry, DailyCompletionEntry, QQueryProperty> {
  QueryBuilder<DailyCompletionEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyCompletionEntry, int, QQueryOperations>
      completionCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completionCount');
    });
  }

  QueryBuilder<DailyCompletionEntry, double, QQueryOperations>
      completionPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completionPercent');
    });
  }

  QueryBuilder<DailyCompletionEntry, String, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }
}
