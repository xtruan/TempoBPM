class QuickSort {

    function quickSort(arr, low, high) {
        if (low < high) {
            var pi = partition(arr, low, high);
            quickSort(arr, low, pi - 1);
            quickSort(arr, pi + 1, high);
        }
    }
    
    function partition(arr, low, high) {
        var pivot = arr[high];
        var i = low - 1;
        
        for (var j = low; j < high; j++) {
            if (arr[j] <= pivot) {
                i++;
                // Swap elements
                var temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }
        
        // Place pivot in correct position
        var temp = arr[i + 1];
        arr[i + 1] = arr[high];
        arr[high] = temp;
        
        return i + 1;
    }
    
    function sort(sorted) {
        quickSort(sorted, 0, sorted.size() - 1);
    }

}