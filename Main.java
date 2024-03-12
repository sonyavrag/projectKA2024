import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException {
        int[] numbers = new int[10000];
        int counter = 0;

        String line = DataInput.getMyString("Введіть рядок з цифрами, розділеними пробілами: ");

        String[] elementsArray = line.split(" ");
        // перетворює елементи стрічки на цілі числа та записує їх у масив
        for (String e : elementsArray) {
            int element = Integer.parseInt(e);
            numbers[counter++] = element;
        }
        mergeSort(numbers, 0, counter - 1);

        System.out.println("Медіана: " + calculateMediana(counter, numbers));
        System.out.println("Середнє значення: " + calculateAverage(counter, numbers));
    }

    // розбиває масив на дві половини та сортує далі кожну половину, поки елементи не стануть одиничними
    private static void mergeSort(int[] array, int left, int right) {
        if (left < right) {
            int middleElementIndex = (left + right) / 2;
            mergeSort(array, left, middleElementIndex);
            mergeSort(array, middleElementIndex + 1, right);
        }
    }

    private static double calculateMediana(int counter, int[] numbers) {
        double mediana;
        if (counter % 2 == 0) {
            int middleElementIndex = counter / 2;
            mediana = (numbers[middleElementIndex - 1] + numbers[middleElementIndex]) / 2.0;
        } else {
            mediana = numbers[counter / 2];
        }
        return mediana;
    }

    private static double calculateAverage(int counter, int[] numbers) {
        double sum = 0;
        for (int i = 0; i < counter; i++) {
            sum += numbers[i];
        }
        return sum / counter;
    }
}
