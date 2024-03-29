import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException {
        while (true) {
            int[] numbers = new int[10000];
            int counter = 0;

            String line = DataInput.getMyString("Введіть рядок з цифрами, розділеними пробілами: ");

            String[] elementsArray = line.split(" ");
            // перетворює елементи стрічки на цілі числа та записує їх у масив
            for (String e : elementsArray) {
                int element = Integer.parseInt(e);
                numbers[counter++] = Integer.parseInt(Integer.toBinaryString(element));
            }
            mergeSort(numbers, 0, counter - 1);

            System.out.println("Медіана: " + Integer.parseInt(calculateMediana(counter, numbers), 2));
            System.out.println("Середнє значення: " + Integer.parseInt(calculateAverage(counter, numbers), 2));
            int check = DataInput.getInt("Повторити операцію? ТАК - 1, НІ - 2. ");
            if (check == 2) break;
        }
    }

    // розбиває масив на дві половини та сортує далі кожну половину, поки елементи не стануть одиничними, після підмасиви обʼєднуються в один відсортований масив
    private static void mergeSort(int[] array, int firstElementOf1SubArrayIndex, int lastElementOf2SubArrayIndex) {
        // перевірка, чи більше одного елемента в масиві
        if (firstElementOf1SubArrayIndex < lastElementOf2SubArrayIndex) {
            int middleElementIndex = (firstElementOf1SubArrayIndex + lastElementOf2SubArrayIndex) / 2;
            mergeSort(array, firstElementOf1SubArrayIndex, middleElementIndex);
            mergeSort(array, middleElementIndex + 1, lastElementOf2SubArrayIndex);
            merge(array, firstElementOf1SubArrayIndex, middleElementIndex, lastElementOf2SubArrayIndex);
        }
    }

    private static String calculateMediana(int counter, int[] numbers) {
        String mediana;
        if (counter % 2 == 0) {
            int middleElementIndex = counter / 2;
            mediana = Integer.toBinaryString((Integer.parseInt(String.valueOf(numbers[middleElementIndex - 1]), 2)
                    + Integer.parseInt(String.valueOf(numbers[middleElementIndex]), 2)) / 2);
            ;
        } else {
            mediana = String.valueOf(numbers[counter / 2]);
        }
        return mediana;
    }

    private static String calculateAverage(int counter, int[] numbers) {
        int sum = 0;
        for (int i = 0; i < counter; i++) {
            sum += Integer.parseInt(String.valueOf(numbers[i]), 2);
        }
        return Integer.toBinaryString((sum / counter));
    }

    // обʼєднує два відсортовані підмасиви
    private static void merge(int[] array, int firstElementOf1SubArrayIndex, int middleElementIndex, int lastElementOf2SubArrayIndex) {
        int[] temporaryArray = new int[lastElementOf2SubArrayIndex - firstElementOf1SubArrayIndex + 1];

        int startOf1SubArray = firstElementOf1SubArrayIndex;
        int startOf2SubArray = middleElementIndex + 1;
        int startOfTemporaryArray = 0;

        while (startOf1SubArray <= middleElementIndex && startOf2SubArray <= lastElementOf2SubArrayIndex) {
            // елемент з 1 підмасиву менший або дорівнює елементу з 2 підмасиву
            if (array[startOf1SubArray] <= array[startOf2SubArray]) {
                temporaryArray[startOfTemporaryArray++] = array[startOf1SubArray++];
            } else {
                // елемент з 2 підмасиву менший за елемент з 1 підмасиву
                temporaryArray[startOfTemporaryArray++] = array[startOf2SubArray++];
            }
        }
        // поки не закінчився 1 підмасив
        while (startOf1SubArray <= middleElementIndex) {
            temporaryArray[startOfTemporaryArray++] = array[startOf1SubArray++];
        }
        // поки не закінчився 2 підмасив
        while (startOf2SubArray <= lastElementOf2SubArrayIndex) {
            temporaryArray[startOfTemporaryArray++] = array[startOf2SubArray++];
        }
        for (int i = 0; i < temporaryArray.length; i++) {
            array[firstElementOf1SubArrayIndex + i] = temporaryArray[i];
        }
    }
}
