import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from processor.base_processor import BaseProcessor


class NormalizeJsonNumbersTest(unittest.TestCase):
    def test_only_integral_floats_are_converted(self):
        value = {
            "integer_float": 1.0,
            "fraction": 1.5,
            "text": "20.0%",
            "nested": [2.0, {"negative": -3.0}],
        }

        self.assertEqual(
            BaseProcessor._normalize_json_numbers(value),
            {
                "integer_float": 1,
                "fraction": 1.5,
                "text": "20.0%",
                "nested": [2, {"negative": -3}],
            },
        )


if __name__ == "__main__":
    unittest.main()
