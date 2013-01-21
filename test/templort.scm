(test-begin "templort")
(let ((renderer (make-renderer "test/views")))
  (test "Should load templates without interpolated forms"
        "Rawr Test Thing"
        (renderer "no_interpolated_forms.html"))

  (test "Should render templates without interpolated forms"
        "Rawr Test Thing"
        (renderer "no_interpolated_forms.html"))

  (test "Should render templates without interpolated forms with locals"
        "Rawr Test Thing"
        (renderer "no_interpolated_forms.html" '((foo . "rawr"))))

  (test "Should render templates with interpolated forms"
        "Rawr Test buttslol Foo"
        (renderer "interpolated_forms.html"))

  (test "Should render templates with escaped forms"
        "Rawr Test (hello world)"
        (renderer "escaped_forms.html"))

  (test "Should render templates with inline html"
        "<html><head><title>butts</title></head><body>lols</body></html>"
        (renderer "inline_html.html"))

  (test "Should render templates with local variables"
        "rawr test butts"
        (renderer "local_variables.html" '((key . "butts"))))

  (test "Should include variables from local scope"
        "rawr test butts"
        (let ((somevar "butts"))
          (renderer "local_variables.html" `((key . ,somevar)))))

  (test "Should handle inline variables in other forms"
        "test trololol test"
        (renderer "inline_list_variable.html" '((key . "trololol"))))

  (test "Should be able to do inline scheme with nested forms"
        "0 1 2 3 4 5 6 7 8 9 10"
        (renderer "count.html" '((to . 10))))

  (test "Interpolated complex data structures"
        "beep This is a test boop"
        (let ((st '((baz . "This is a test") (foo . bar) )))
          (renderer "complex_data_structures.html" (alist-cons 'key st '()))))
          ; (cdr (assoc 'baz st))))
         )

(test-end)
