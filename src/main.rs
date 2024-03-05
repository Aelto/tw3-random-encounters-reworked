fn main() {}

#[test]
fn test_scaling() {
    fn scale(input: f32, intensity: f32, scale: f32) -> f32 {
        (input) * (intensity.powf(scale))
    }

    fn round(input: f32) -> f32 {
        (input * 10.0).round() * 0.1
    }

    let seconds = 5.0;
    assert_eq!(
        scale(seconds, 1.0, 1.0),
        seconds,
        "confirm intensity & scaling of 1.0 result in unchanged values"
    );

    assert_eq!(
        scale(seconds, 2.0, 1.0),
        seconds * 2.0,
        "confirm an intensity of 2.0 with a scaling of 1.0 simply doubles the values"
    );

    assert_eq!(scale(seconds, 0.5, 1.0), seconds * 0.5);

    assert!(scale(seconds, 2.0, 0.5) > scale(seconds, 2.0, 0.4));
    assert_eq!(round(scale(seconds, 2.0, 0.5)), 7.1);

    assert!(scale(seconds, 0.5, 0.5) < scale(seconds, 0.5, 0.4));
    assert_eq!(round(scale(seconds, 0.5, 0.5)), 3.5);

    assert_eq!(round(scale(seconds, 1.0, -1.0)), seconds);
    assert_eq!(
        round(scale(seconds, 1.0, -1.5)),
        seconds,
        "confirm a negative scaling diff than 1 doesn't change the values as long as the intensity is at 1"
    );
    assert!(round(scale(seconds, 1.5, -1.0)) > round(scale(seconds, 2.0, -1.0)));
    assert!(round(scale(seconds, 1.5, -1.0)) > round(scale(seconds, 1.5, -2.0)));
}
