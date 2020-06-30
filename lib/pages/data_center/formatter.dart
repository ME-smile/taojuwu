import 'package:common_utils/common_utils.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/axis/axis_base.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_line_data_set.dart';
import 'package:mp_chart/mp/core/data_provider/line_data_provider.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/fill_formatter/i_fill_formatter.dart';
import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';

class DateTimeFormatter extends ValueFormatter {
  String getformatDateTime(Entry entry) {
    DateTime dateTime = entry.mData;
    return type == 4
        ? DateUtil.formatDate(dateTime, format: 'M月')
        : DateUtil.formatDate(dateTime, format: 'M.d');
  }

  final int type;
  final List<Entry> entries;
  DateTimeFormatter({this.type, this.entries});
  @override
  String getAxisLabel(double value, AxisBase axis) {
    return getformatDateTime(entries[value.toInt()]);
  }
}

class NameFormatter extends ValueFormatter {
  final List<Entry> entries;
  NameFormatter(this.entries);

  String getformattedName(Entry entry) {
    return entry.mData;
  }

  @override
  String getAxisLabel(double value, AxisBase axis) {
    return getformattedName(entries[value.toInt()]);
  }
}

class A implements IFillFormatter {
  LineChartController _controller;

  void setPainter(LineChartController controller) {
    _controller = controller;
  }

  @override
  double getFillLinePosition(
      ILineDataSet dataSet, LineDataProvider dataProvider) {
    return _controller?.painter?.axisLeft?.axisMinimum;
  }
}
