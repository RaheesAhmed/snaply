import 'package:flutter/material.dart';
import '../theme/snaply_theme.dart';

/// A showcase of the Snaply theme components to display the premium design system
class ThemeShowcase extends StatelessWidget {
  const ThemeShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Snaply Design System'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SnaplyTheme.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color Palette Section
            _buildSectionHeader(theme, 'Color Palette'),
            _buildColorPalette(theme),
            SizedBox(height: SnaplyTheme.spaceLG),

            // Typography Section
            _buildSectionHeader(theme, 'Typography'),
            _buildTypography(theme),
            SizedBox(height: SnaplyTheme.spaceLG),

            // Buttons Section
            _buildSectionHeader(theme, 'Buttons'),
            _buildButtons(theme),
            SizedBox(height: SnaplyTheme.spaceLG),

            // Form Elements Section
            _buildSectionHeader(theme, 'Form Elements'),
            _buildFormElements(theme),
            SizedBox(height: SnaplyTheme.spaceLG),

            // Cards Section
            _buildSectionHeader(theme, 'Cards'),
            _buildCards(theme),
            SizedBox(height: SnaplyTheme.spaceLG),

            // Dialogs Section
            _buildSectionHeader(theme, 'Dialogs & Alerts'),
            _buildDialogButtons(theme, context),
            SizedBox(height: SnaplyTheme.spaceLG),

            // Spacing Section
            _buildSectionHeader(theme, 'Spacing Scale'),
            _buildSpacingScale(theme),
            SizedBox(height: SnaplyTheme.spaceLG),
          ],
        ),
      ),
    );
  }

  // Section header with premium styling
  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: SnaplyTheme.spaceSM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall,
          ),
          SizedBox(height: SnaplyTheme.spaceXS),
          Container(
            width: 32,
            height: 2,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  // Color palette showcase
  Widget _buildColorPalette(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: SnaplyTheme.spaceSM,
          runSpacing: SnaplyTheme.spaceSM,
          children: [
            _buildColorItem(theme, 'Primary', theme.colorScheme.primary),
            _buildColorItem(theme, 'Secondary', theme.colorScheme.secondary),
            _buildColorItem(theme, 'Tertiary', theme.colorScheme.tertiary),
            _buildColorItem(theme, 'Error', theme.colorScheme.error),
            _buildColorItem(theme, 'Surface', theme.colorScheme.surface),
            _buildColorItem(theme, 'Background', theme.colorScheme.background),
          ],
        ),
        SizedBox(height: SnaplyTheme.spaceSM),
        Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: SnaplyTheme.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            'Primary Gradient',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // Individual color item with label
  Widget _buildColorItem(ThemeData theme, String label, Color color) {
    final bool isDark =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark;

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: SnaplyTheme.subtleShadow,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  // Typography showcase
  Widget _buildTypography(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display Large', style: theme.textTheme.displayLarge),
        SizedBox(height: SnaplyTheme.spaceXS),
        Text('Display Medium', style: theme.textTheme.displayMedium),
        SizedBox(height: SnaplyTheme.spaceXS),
        Text('Display Small', style: theme.textTheme.displaySmall),
        SizedBox(height: SnaplyTheme.spaceSM),
        Text('Headline Large', style: theme.textTheme.headlineLarge),
        SizedBox(height: SnaplyTheme.spaceXS),
        Text('Headline Medium', style: theme.textTheme.headlineMedium),
        SizedBox(height: SnaplyTheme.spaceXS),
        Text('Headline Small', style: theme.textTheme.headlineSmall),
        SizedBox(height: SnaplyTheme.spaceSM),
        Text('Title Large', style: theme.textTheme.titleLarge),
        SizedBox(height: SnaplyTheme.spaceXS),
        Text('Title Medium', style: theme.textTheme.titleMedium),
        SizedBox(height: SnaplyTheme.spaceXS),
        Text('Title Small', style: theme.textTheme.titleSmall),
        SizedBox(height: SnaplyTheme.spaceSM),
        Text('Body Large', style: theme.textTheme.bodyLarge),
        SizedBox(height: SnaplyTheme.spaceXS),
        Text('Body Medium', style: theme.textTheme.bodyMedium),
        SizedBox(height: SnaplyTheme.spaceXS),
        Text('Body Small', style: theme.textTheme.bodySmall),
        SizedBox(height: SnaplyTheme.spaceSM),
        Text('Label Large', style: theme.textTheme.labelLarge),
        SizedBox(height: SnaplyTheme.spaceXS),
        Text('Label Medium', style: theme.textTheme.labelMedium),
        SizedBox(height: SnaplyTheme.spaceXS),
        Text('Label Small', style: theme.textTheme.labelSmall),
      ],
    );
  }

  // Button variants showcase
  Widget _buildButtons(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Elevated Button (Primary)'),
        SizedBox(height: SnaplyTheme.spaceXS),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Get Started'),
        ),
        SizedBox(height: SnaplyTheme.spaceSM),
        const Text('Outlined Button (Secondary)'),
        SizedBox(height: SnaplyTheme.spaceXS),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Learn More'),
        ),
        SizedBox(height: SnaplyTheme.spaceSM),
        const Text('Text Button (Tertiary)'),
        SizedBox(height: SnaplyTheme.spaceXS),
        TextButton(
          onPressed: () {},
          child: const Text('View Details'),
        ),
        SizedBox(height: SnaplyTheme.spaceSM),
        const Text('Icon Button'),
        SizedBox(height: SnaplyTheme.spaceXS),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_outline),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bookmark_outline),
            ),
          ],
        ),
      ],
    );
  }

  // Form elements showcase
  Widget _buildFormElements(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Email Address',
            hintText: 'example@email.com',
          ),
        ),
        SizedBox(height: SnaplyTheme.spaceSM),
        TextField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
          ),
        ),
        SizedBox(height: SnaplyTheme.spaceSM),
        Row(
          children: [
            Checkbox(
              value: true,
              onChanged: (value) {},
            ),
            const Text('Remember me'),
            SizedBox(width: SnaplyTheme.spaceMD),
            Checkbox(
              value: false,
              onChanged: (value) {},
            ),
            const Text('Subscribe'),
          ],
        ),
        SizedBox(height: SnaplyTheme.spaceSM),
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: true,
              onChanged: (value) {},
            ),
            const Text('Option 1'),
            SizedBox(width: SnaplyTheme.spaceMD),
            Radio<bool>(
              value: false,
              groupValue: true,
              onChanged: (value) {},
            ),
            const Text('Option 2'),
          ],
        ),
        SizedBox(height: SnaplyTheme.spaceSM),
        const Text('Slider:'),
        Slider(
          value: 0.7,
          onChanged: (value) {},
        ),
      ],
    );
  }

  // Cards showcase
  Widget _buildCards(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Standard card
        Card(
          child: Padding(
            padding: EdgeInsets.all(SnaplyTheme.spaceMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Standard Card',
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: SnaplyTheme.spaceXS),
                Text(
                  'This is a basic card with standard styling from the Snaply theme system.',
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: SnaplyTheme.spaceSM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Cancel'),
                    ),
                    SizedBox(width: SnaplyTheme.spaceXS),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: SnaplyTheme.spaceSM),

        // Premium card with gradient border
        Container(
          decoration: BoxDecoration(
            gradient: SnaplyTheme.primaryGradient,
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(2),
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(SnaplyTheme.spaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: SnaplyTheme.spaceXS),
                      Text(
                        'Premium Card',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: SnaplyTheme.spaceXS),
                  Text(
                    'This premium card features a gradient border and special styling for highlighted content.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: SnaplyTheme.spaceSM),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Upgrade Now'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Dialog buttons showcase
  Widget _buildDialogButtons(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () => _showStandardDialog(context),
          child: const Text('Show Standard Dialog'),
        ),
        SizedBox(height: SnaplyTheme.spaceSM),
        ElevatedButton(
          onPressed: () => _showActionDialog(context),
          child: const Text('Show Action Dialog'),
        ),
        SizedBox(height: SnaplyTheme.spaceSM),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This is a snackbar message'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: const Text('Show Snackbar'),
        ),
      ],
    );
  }

  // Standard dialog example
  void _showStandardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dialog Title'),
        content: const Text(
          'This is a standard dialog with a message and actions. Dialogs inform users about critical information or ask for user input.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  // Action dialog example
  void _showActionDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: EdgeInsets.all(SnaplyTheme.spaceLG),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_fix_high,
                  color: theme.colorScheme.primary,
                  size: 30,
                ),
              ),
              SizedBox(height: SnaplyTheme.spaceMD),
              Text(
                'Enhanced Image Ready',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SnaplyTheme.spaceXS),
              Text(
                'Your image has been enhanced with AI and is ready to download.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SnaplyTheme.spaceLG),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Download Image'),
                ),
              ),
              SizedBox(height: SnaplyTheme.spaceXS),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Spacing scale showcase
  Widget _buildSpacingScale(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSpacingItem(theme, 'XXS (4dp)', SnaplyTheme.spaceXXS),
        _buildSpacingItem(theme, 'XS (8dp)', SnaplyTheme.spaceXS),
        _buildSpacingItem(theme, 'SM (12dp)', SnaplyTheme.spaceSM),
        _buildSpacingItem(theme, 'MD (16dp)', SnaplyTheme.spaceMD),
        _buildSpacingItem(theme, 'LG (24dp)', SnaplyTheme.spaceLG),
        _buildSpacingItem(theme, 'XL (32dp)', SnaplyTheme.spaceXL),
        _buildSpacingItem(theme, 'XXL (48dp)', SnaplyTheme.spaceXXL),
      ],
    );
  }

  // Individual spacing item
  Widget _buildSpacingItem(ThemeData theme, String label, double size) {
    return Padding(
      padding: EdgeInsets.only(bottom: SnaplyTheme.spaceXS),
      child: Row(
        children: [
          Container(
            width: size,
            height: 24,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: SnaplyTheme.spaceSM),
          Text(label, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
